# frozen_string_literal: true

class SpecialtiesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :set_specialty, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[edit update destroy]

  # 地方ブロックと都道府県IDの対応（地図SVGから渡されるパラメータ）
  REGION_BLOCKS = {
    'tohoku'  => [2, 3, 4, 5, 6, 7],
    'kanto'   => [8, 9, 10, 11, 12, 13, 14],
    'chubu'   => [15, 16, 17, 18, 19, 20, 21, 22, 23],
    'kinki'   => [24, 25, 26, 27, 28, 29, 30],
    'chugoku' => [31, 32, 33, 34, 35],
    'shikoku' => [36, 37, 38, 39],
    'kyushu'  => [40, 41, 42, 43, 44, 45, 46, 47]
  }.freeze

  # 地方ブロック名（表示用）
  REGION_BLOCK_NAMES = {
    'tohoku'  => '東北',
    'kanto'   => '関東',
    'chubu'   => '中部',
    'kinki'   => '近畿',
    'chugoku' => '中国',
    'shikoku' => '四国',
    'kyushu'  => '九州・沖縄'
  }.freeze

  # 一覧表示
  def index
    @q = Specialty.ransack(params[:q])
    base = @q.result

    # 地方ブロックフィルター（地図SVGからのパラメータ、Ransackを使わずwhere）
    if params[:region_block].present? && REGION_BLOCKS.key?(params[:region_block])
      base = base.where(region_id: REGION_BLOCKS[params[:region_block]])
      @region_block_name = REGION_BLOCK_NAMES[params[:region_block]]
    end

    @specialties = case params[:sort]
                   when 'popular'
                     base.left_joins(:favorites).group('specialties.id').order('COUNT(favorites.id) DESC')
                   when 'comments'
                     base.left_joins(:comments).group('specialties.id').order('COUNT(comments.id) DESC')
                   else
                     base.distinct.order(created_at: :desc)
                   end

    @specialties = @specialties
                     .includes(:user, :region, :favorites, :tags)
                     .page(params[:page])
    @specialties = @specialties.joins(:tags).where(tags: { name: params[:tag].downcase.strip }) if params[:tag].present?
    @regions = Region.order(:name)
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
  end

  # 編集フォーム
  def edit
    # @specialty は set_specialty で設定済み
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

  private

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
