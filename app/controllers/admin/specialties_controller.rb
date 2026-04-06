# frozen_string_literal: true

module Admin
  class SpecialtiesController < Admin::BaseController
    before_action :set_specialty, only: %i[edit update destroy]

    def index
      @specialties = Specialty.includes(:user, :region).order(created_at: :desc)
    end

    def edit; end

    def update
      if @specialty.update(specialty_params)
        redirect_to admin_specialties_path, notice: '銘菓情報を更新しました'
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @specialty.destroy
      redirect_to admin_specialties_path, notice: '銘菓を削除しました'
    end

    private

    def set_specialty
      @specialty = Specialty.find(params[:id])
    end

    def specialty_params
      params.require(:specialty).permit(:name, :description, :region_id)
    end
  end
end
