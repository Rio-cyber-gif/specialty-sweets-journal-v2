# frozen_string_literal: true

class ApplicationController < ActionController::Base
  add_flash_types :success, :danger
  # 全てのアクションで認証を要求
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # 新規登録時にnameを許可
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    # アカウント更新時にname・bio・avatarを許可
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name bio avatar])
  end
end
