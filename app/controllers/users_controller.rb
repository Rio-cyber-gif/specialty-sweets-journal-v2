# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

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
