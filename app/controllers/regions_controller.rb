# frozen_string_literal: true

class RegionsController < ApplicationController
  def show
    @region = Region.find(params[:id])
    @specialties = @region.specialties
                          .publicly_visible
                          .includes(:user, :favorites, :tags)
                          .order(created_at: :desc)
                          .page(params[:page])
                          .per(9)
  end
end
