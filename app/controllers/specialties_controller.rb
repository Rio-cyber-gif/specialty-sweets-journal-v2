# frozen_string_literal: true

class SpecialtiesController < ApplicationController
  include RegionSupport

  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :set_specialty, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[edit update destroy]

  # 一覧表示
  def index
    @q           = Specialty.ransack(params[:q])
    @specialties = sorted_specialties(filtered_base)
    @regions     = Region.order(:name)
  end

  # 詳細表示
  def show
    @comment = Comment.new
    @comments = @specialty.comments.includes(:user).order(created_at: :desc)
    @related_specialties = @specialty.region.specialties
                                     .where.not(id: @specialty.id)
                                     .includes(:favorites)
                                     .order(created_at: :desc)
                                     .limit(3)
  end

  # 新規作成フォーム
  def new
    @specialty = Specialty.new
    @grouped_regions = build_grouped_regions
  end

  # 編集フォーム
  def edit
    @grouped_regions = build_grouped_regions
  end

  # 新規作成処理
  def create
    @specialty = current_user.specialties.build(specialty_params)

    if @specialty.save
      redirect_to @specialty, success: '銘菓を登録しました'
    else
      flash.now[:danger] = '銘菓の登録に失敗しました'
      render :new, status: :unprocessable_content
    end
  end

  # 更新処理
  def update
    if @specialty.update(specialty_params)
      redirect_to @specialty, success: '銘菓を更新しました'
    else
      flash.now[:danger] = '銘菓の更新に失敗しました'
      render :edit, status: :unprocessable_content
    end
  end

  # 削除処理
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
    apply_tag_filter(apply_sort(base).includes(:user, :region, :favorites, :tags).page(params[:page]))
  end

  def apply_sort(base)
    SORT_SCOPES.fetch(params[:sort], ->(b) { b.distinct.order(created_at: :desc) }).call(base)
  end

  def apply_tag_filter(scope)
    return scope.joins(:tags).where(tags: { name: params[:tag].downcase.strip }) if params[:tag].present?

    scope
  end

  # パラメータの許可
  def specialty_params
    params.require(:specialty).permit(:name, :region_id, :description, :image, :tag_list)
  end

  # 銘菓の取得
  def set_specialty
    @specialty = Specialty.includes(:favorites, :tags).find(params[:id])
  end

  # 権限チェック（自分の銘菓のみ編集・削除可能）
  def authorize_user!
    redirect_to specialties_path, danger: '権限がありません' unless @specialty.user == current_user
  end
end
