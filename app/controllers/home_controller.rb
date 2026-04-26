# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @q            = Specialty.publicly_visible.ransack(params[:q])
    @specialties  = filtered_specialties
    @regions      = Region.order(:name)
    @popular_specialties = popular_specialties
    @recent_activities   = recent_activities
    @block_counts        = block_counts
    @recent_commented_ids = Comment.where('created_at > ?', 24.hours.ago)
                                   .distinct
                                   .pluck(:specialty_id)
                                   .to_set
  end

  private

  def filtered_specialties
    scope = @q.result(distinct: true)
              .includes({ user: { avatar_attachment: :blob } }, :region, :tags, :favorites, :comments)
              .order(created_at: :desc)
              .page(params[:page])
              .per(6)
    return scope.joins(:tags).where(tags: { name: params[:tag].downcase.strip }) if params[:tag].present?

    scope
  end

  def popular_specialties
    Specialty.publicly_visible
             .left_joins(:favorites)
             .group(:id)
             .order('COUNT(favorites.id) DESC')
             .limit(5)
             .includes(:region, :favorites)
  end

  def recent_activities
    (recent_posts + recent_comments).sort_by { |a| -a[:created_at].to_i }.first(5)
  end

  def recent_posts
    Specialty.publicly_visible
             .includes(:region, :user)
             .order(created_at: :desc)
             .limit(5)
             .map { |s| { type: :post, record: s, created_at: s.created_at } }
  end

  def recent_comments
    Comment.includes(:user, specialty: :region)
           .order(created_at: :desc)
           .limit(5)
           .map { |c| { type: :comment, record: c, created_at: c.created_at } }
  end

  def block_counts
    region_counts = Specialty.publicly_visible.group(:region_id).count
    blocks = SpecialtiesController::REGION_BLOCKS
    counts = blocks.transform_values { |ids| region_counts.slice(*ids).values.sum }
    counts.merge('hokkaido' => region_counts.slice(1).values.sum)
  end
end
