# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @q = Specialty.ransack(params[:q])
    @specialties = @q.result(distinct: true)
                     .includes(:user, :region, :tags)
                     .order(created_at: :desc)
                     .page(params[:page])
                     .per(6)
    @specialties = @specialties.joins(:tags).where(tags: { name: params[:tag].downcase.strip }) if params[:tag].present?
    @regions = Region.order(:name)
    @categories = Category.all
    @popular_specialties = Specialty
      .left_joins(:favorites)
      .group(:id)
      .order('COUNT(favorites.id) DESC')
      .limit(10)
      .includes(:region)

    # ツリーマップ用: 地方ブロックごとの件数
    region_counts = Specialty.group(:region_id).count
    blocks = SpecialtiesController::REGION_BLOCKS
    @block_counts = {
      'hokkaido' => region_counts.slice(1).values.sum,
      'tohoku'   => region_counts.slice(*blocks['tohoku']).values.sum,
      'kanto'    => region_counts.slice(*blocks['kanto']).values.sum,
      'chubu'    => region_counts.slice(*blocks['chubu']).values.sum,
      'chugoku'  => region_counts.slice(*blocks['chugoku']).values.sum,
      'kinki'    => region_counts.slice(*blocks['kinki']).values.sum,
      'kyushu'   => region_counts.slice(*blocks['kyushu']).values.sum,
      'shikoku'  => region_counts.slice(*blocks['shikoku']).values.sum
    }
  end

  def create_sample_data
    return if Rails.env.production?

    create_sample_categories
    create_sample_regions
    create_sample_specialties

    redirect_to root_path, notice: 'Sample data has been created'
  end

  private

  def create_sample_categories
    Category.create!([
                       { name: '和菓子', description: '伝統的な日本のお菓子' },
                       { name: '洋菓子', description: '西洋風のお菓子' },
                       { name: '駄菓子', description: '懐かしい味の駄菓子' }
                     ])
  end

  def create_sample_regions
    Region.create!([
                     { name: '北海道', description: '北の大地の特産品' },
                     { name: '東京', description: '首都の特産品' },
                     { name: '大阪', description: '関西の特産品' }
                   ])
  end

end
