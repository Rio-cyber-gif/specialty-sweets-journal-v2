# frozen_string_literal: true

class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_specialty

  def create
    current_user.favorites.create!(specialty: @specialty)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @specialty, success: 'お気に入りに追加しました' }
    end
  rescue ActiveRecord::RecordInvalid
    redirect_to @specialty, danger: 'お気に入りの追加に失敗しました'
  end

  def destroy
    favorite = current_user.favorites.find_by!(specialty: @specialty)
    favorite.destroy!
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @specialty, success: 'お気に入りを解除しました' }
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to @specialty, danger: 'お気に入りが見つかりません'
  end

  private

  def set_specialty
    @specialty = Specialty.find(params[:specialty_id])
  end
end
