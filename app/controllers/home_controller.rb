# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @q            = Specialty.ransack(params[:q])
    @specialties  = filtered_specialties
    @regions      = Region.order(:name)
    @popular_specialties = popular_specialties
    @block_counts = block_counts
  end

  private

  def filtered_specialties
    scope = @q.result(distinct: true)
              .includes(:user, :region, :tags)
              .order(created_at: :desc)
              .page(params[:page])
              .per(6)
    return scope.joins(:tags).where(tags: { name: params[:tag].downcase.strip }) if params[:tag].present?

    scope
  end

  def popular_specialties
    Specialty.left_joins(:favorites)
             .group(:id)
             .order('COUNT(favorites.id) DESC')
             .limit(10)
             .includes(:region)
  end

  def block_counts
    region_counts = Specialty.group(:region_id).count
    blocks = SpecialtiesController::REGION_BLOCKS
    counts = blocks.transform_values { |ids| region_counts.slice(*ids).values.sum }
    counts.merge('hokkaido' => region_counts.slice(1).values.sum)
  end
end
