# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[mypage update_profile]

  def show
    @user = User.find(params[:id])
    @specialties = @user.specialties
                        .publicly_visible
                        .includes(:region, :favorites, :tags)
                        .order(created_at: :desc)
                        .page(params[:page]).per(9)
  end

  def update_profile
    handle_avatar_update
    if current_user.update(profile_params)
      redirect_to edit_user_registration_path, success: 'プロフィールを更新しました'
    else
      redirect_to edit_user_registration_path, danger: current_user.errors.full_messages.join('、')
    end
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

  private

  def handle_avatar_update
    current_user.avatar.purge if params[:user][:remove_avatar] == '1' && current_user.avatar.attached?
    params[:user].delete(:avatar) if params[:user][:avatar].blank?
  end

  def profile_params
    params.require(:user).permit(:name, :bio, :avatar, :remove_avatar)
  end
end
