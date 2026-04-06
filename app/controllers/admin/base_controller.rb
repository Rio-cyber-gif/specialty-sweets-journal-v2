# frozen_string_literal: true

module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user! # Deviseのログイン認証
    before_action :check_admin # 管理者権限チェック

    layout 'admin' # 管理画面専用のレイアウトを使用

    private

    def check_admin
      return if current_user.admin?

      redirect_to root_path, alert: '管理者権限が必要です'
    end
  end
end
