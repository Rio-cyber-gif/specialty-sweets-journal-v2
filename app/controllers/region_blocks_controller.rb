# frozen_string_literal: true

class RegionBlocksController < ApplicationController
  REGION_BLOCKS = SpecialtiesController::REGION_BLOCKS
  REGION_BLOCK_NAMES = SpecialtiesController::REGION_BLOCK_NAMES

  def show
    block_key = params[:block]
    redirect_to root_path unless REGION_BLOCKS.key?(block_key)

    @block_name = REGION_BLOCK_NAMES[block_key]
    @specialties = Specialty
                   .publicly_visible
                   .where(region_id: REGION_BLOCKS[block_key])
                   .includes(:user, :favorites, :tags, :region)
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(9)
  end
end
