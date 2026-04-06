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

end
