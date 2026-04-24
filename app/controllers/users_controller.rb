# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:mypage]

  def show
    @user = User.find(params[:id])
    @specialties = @user.specialties
                        .publicly_visible
                        .includes(:region, :favorites, :tags)
                        .order(created_at: :desc)
                        .page(params[:page]).per(9)
  end

  def mypage
    @my_specialties = current_user.specialties
                                  .includes(:region, :favorites, :tags)
                                  .order(created_at: :desc)
                                  .page(params[:my_page]).per(6)
    @favorite_specialties = current_user.favorited_specialties
                                        .includes(:region, :user, :favorites, :tags)
                                        .order('favorites.created_at desc')
                                        .page(params[:fav_page]).per(6)
  end
end
