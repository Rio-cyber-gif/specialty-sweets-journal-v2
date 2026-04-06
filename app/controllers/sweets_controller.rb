# frozen_string_literal: true

class SweetsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :set_sweet, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[edit update destroy]

  def show
    # @sweetはbefore_actionで設定済み
  end

  def new
    @sweet = Sweet.new
    @genres = Genre.all
    @regions = Region.all
  end

  def edit
    @genres = Genre.all
    @regions = Region.all
  end

  def create
    @sweet = current_user.sweets.build(sweet_params)
    if @sweet.save
      redirect_to sweet_path(@sweet), notice: '銘菓を投稿しました'
    else
      @genres = Genre.all
      @regions = Region.all
      flash.now[:alert] = '銘菓を投稿できませんでした'
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @sweet.update(sweet_params)
      redirect_to sweet_path(@sweet), notice: '銘菓を更新しました'
    else
      @genres = Genre.all
      @regions = Region.all
      flash.now[:alert] = '銘菓を更新できませんでした'
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @sweet.destroy!
    redirect_to root_path, notice: '銘菓を削除しました'
  end

  private

  def set_sweet
    @sweet = Sweet.find(params[:id])
  end

  def authorize_user!
    return if @sweet.user == current_user

    redirect_to root_path, alert: '権限がありません'
  end

  def sweet_params
    params.require(:sweet).permit(:name, :description, :genre_id, :region_id, :image)
  end
end
