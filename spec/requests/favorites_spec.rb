# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Favorites', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:specialty) { create(:specialty) }

  describe 'POST /specialties/:specialty_id/favorite' do
    context '未ログインの場合' do
      it 'ログインページにリダイレクトされること' do
        post specialty_favorite_path(specialty)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'ログイン済みの場合' do
      before { sign_in user }

      it 'お気に入りが作成されること' do
        expect do
          post specialty_favorite_path(specialty)
        end.to change(Favorite, :count).by(1)
      end

      it '作成されたお気に入りのuserが現在のユーザーであること' do
        post specialty_favorite_path(specialty)
        expect(Favorite.last.user).to eq(user)
      end

      it '同一specialtyへの重複登録はできないこと' do
        create(:favorite, user: user, specialty: specialty)
        expect do
          post specialty_favorite_path(specialty)
        end.not_to change(Favorite, :count)
      end
    end
  end

  describe 'DELETE /specialties/:specialty_id/favorite' do
    let!(:favorite) { create(:favorite, user: user, specialty: specialty) }

    context '未ログインの場合' do
      it 'ログインページにリダイレクトされること' do
        delete specialty_favorite_path(specialty)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'お気に入り登録済みのユーザーの場合' do
      before { sign_in user }

      it 'お気に入りが削除されること' do
        expect do
          delete specialty_favorite_path(specialty)
        end.to change(Favorite, :count).by(-1)
      end
    end

    context '他のユーザーの場合（IDOR攻撃の防止）' do
      before { sign_in other_user }

      it '他人のお気に入りを削除できないこと（お気に入りが残っていること）' do
        # current_user.favorites.find_by!(specialty: @specialty) でエラーになるため削除されない
        expect do
          delete specialty_favorite_path(specialty)
        end.not_to change(Favorite, :count)
      end

      it 'エラーとしてリダイレクトされること' do
        delete specialty_favorite_path(specialty)
        expect(response).to redirect_to(specialty_path(specialty))
      end
    end
  end
end
