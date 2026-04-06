# frozen_string_literal: true

module Admin
  class DashboardController < Admin::BaseController
    def index
      @users_count = User.count
      @sweets_count = Sweet.count
      @specialties_count = Specialty.count
    end
  end
end
