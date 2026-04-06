# frozen_string_literal: true

module Admin
  class SweetsController < Admin::BaseController
    before_action :set_sweet, only: %i[edit update destroy]

    def index
      @sweets = Sweet.includes(:user, :specialty).order(created_at: :desc)
    end

    def edit; end

    def update
      if @sweet.update(sweet_params)
        redirect_to admin_sweets_path, notice: 'お菓子情報を更新しました'
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @sweet.destroy
      redirect_to admin_sweets_path, notice: 'お菓子を削除しました'
    end

    private

    def set_sweet
      @sweet = Sweet.find(params[:id])
    end

    def sweet_params
      params.require(:sweet).permit(:name, :description, :specialty_id)
    end
  end
end
