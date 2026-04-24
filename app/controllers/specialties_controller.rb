# frozen_string_literal: true

class SpecialtiesController < ApplicationController
  include RegionSupport

  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :set_specialty, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[edit update destroy]

  def index
    @q           = Specialty.publicly_visible.ransack(params[:q])
    @specialties = sorted_specialties(filtered_base)
    @regions     = Region.order(:name)
    @recent_commented_ids = Comment.where('created_at > ?', 24.hours.ago)
                                   .distinct
                                   .pluck(:specialty_id)
                                   .to_set
  end

  def show
    return redirect_to root_path, danger: 'このページは存在しません' if draft_by_other?

    @comment  = Comment.new
    @comments = @specialty.comments
                          .includes(user: { avatar_attachment: :blob })
                          .order(created_at: :desc)
    set_related_specialties
  end

  def new
    @specialty = Specialty.new
    @grouped_regions = build_grouped_regions
  end

  def edit
    @grouped_regions = build_grouped_regions
  end

  def create
    @specialty = current_user.specialties.build(specialty_params)
    @specialty.status = params[:draft].present? ? :draft : :published
    if @specialty.save
      msg = @specialty.draft? ? '下書きを保存しました' : '銘菓を登録しました'
      redirect_to @specialty, success: msg
    else
      flash.now[:danger] = '銘菓の登録に失敗しました'
      render :new, status: :unprocessable_content
    end
  end

  def update
    prepare_specialty_for_update
    if @specialty.update(specialty_params)
      msg = @specialty.draft? ? '下書きを保存しました' : '銘菓を更新しました'
      redirect_to @specialty, success: msg
    else
      flash.now[:danger] = '銘菓の更新に失敗しました'
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @specialty.destroy!
    redirect_to root_path, danger: '銘菓を削除しました'
  end

  SORT_SCOPES = {
    'popular' => ->(b) { b.left_joins(:favorites).group('specialties.id').order('COUNT(favorites.id) DESC') },
    'comments' => ->(b) { b.left_joins(:comments).group('specialties.id').order('COUNT(comments.id) DESC') }
  }.freeze

  private

  def filtered_base
    base = @q.result
    return base unless params[:region_block].present? && REGION_BLOCKS.key?(params[:region_block])

    @region_block_name = REGION_BLOCK_NAMES[params[:region_block]]
    base.where(region_id: REGION_BLOCKS[params[:region_block]])
  end

  def sorted_specialties(base)
    scope = apply_sort(base)
            .includes({ user: { avatar_attachment: :blob } }, :region, :favorites, :tags, :comments)
            .page(params[:page])
    apply_tag_filter(scope)
  end

  def apply_sort(base)
    SORT_SCOPES.fetch(params[:sort], ->(b) { b.distinct.order(created_at: :desc) }).call(base)
  end

  def apply_tag_filter(scope)
    return scope.joins(:tags).where(tags: { name: params[:tag].downcase.strip }) if params[:tag].present?

    scope
  end

  def specialty_params
    params.require(:specialty).permit(:name, :region_id, :description, :image, :tag_list)
  end

  def set_specialty
    @specialty = Specialty.includes(:favorites, :tags).find(params[:id])
  end

  def authorize_user!
    redirect_to specialties_path, danger: '権限がありません' unless @specialty.user == current_user
  end

  def draft_by_other?
    @specialty.draft? && @specialty.user != current_user
  end

  def set_related_specialties
    related_base = @specialty.region.specialties
                             .publicly_visible
                             .where.not(id: @specialty.id)
                             .order(created_at: :desc)
    @related_specialties_count = related_base.count
    @related_specialties       = related_base.includes(:favorites).limit(3)
  end

  def prepare_specialty_for_update
    @specialty.image.purge if params[:specialty][:remove_image] == '1' && @specialty.image.attached?
    @specialty.status = params[:draft].present? ? :draft : :published
  end
end
