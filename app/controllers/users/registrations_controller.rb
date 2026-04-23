# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    # #25 admin アカウントは削除不可
    def destroy
      if current_user.admin?
        redirect_to mypage_path, danger: '管理者アカウントは削除できません'
        return
      end

      super
    end

    protected

    # #26 画像未選択で保存した場合に既存アバターを保持する
    def update_resource(resource, params)
      params.delete(:avatar) if params[:avatar].blank?
      super
    end
  end
end
