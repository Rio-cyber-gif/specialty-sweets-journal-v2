# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:specialty) { create(:specialty) }

  describe 'POST /specialties/:specialty_id/comments' do
    context '未ログインの場合' do
      it 'ログインページにリダイレクトされること' do
        post specialty_comments_path(specialty), params: { comment: { body: 'テスト' } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'ログイン済みの場合' do
      before { sign_in user }

      it '有効なパラメータでコメントが作成できること' do
        expect do
          post specialty_comments_path(specialty), params: { comment: { body: 'テストコメント' } }
        end.to change(Comment, :count).by(1)
      end

      it '空bodyではコメントが作成されないこと' do
        expect do
          post specialty_comments_path(specialty), params: { comment: { body: '' } }
        end.not_to change(Comment, :count)
      end

      it '作成されたコメントのuserが現在のユーザーであること' do
        post specialty_comments_path(specialty), params: { comment: { body: 'テストコメント' } }
        expect(Comment.last.user).to eq(user)
      end
    end
  end

  describe 'DELETE /specialties/:specialty_id/comments/:id' do
    let!(:comment) { create(:comment, user: user, specialty: specialty) }

    context '未ログインの場合' do
      it 'ログインページにリダイレクトされること' do
        delete specialty_comment_path(specialty, comment)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context '投稿者本人の場合' do
      before { sign_in user }

      it 'コメントが削除されること' do
        expect do
          delete specialty_comment_path(specialty, comment)
        end.to change(Comment, :count).by(-1)
      end
    end

    context '他のユーザーの場合（IDOR攻撃の防止）' do
      before { sign_in other_user }

      it '他人のコメントを削除できないこと' do
        expect do
          delete specialty_comment_path(specialty, comment)
        end.not_to change(Comment, :count)
      end

      it 'エラーメッセージ付きでリダイレクトされること' do
        delete specialty_comment_path(specialty, comment)
        expect(response).to redirect_to(specialty_path(specialty))
      end
    end

    context '別のspecialtyのコメントIDを指定した場合（IDOR攻撃の防止）' do
      let(:other_specialty) { create(:specialty) }
      let!(:other_comment) { create(:comment, user: user, specialty: other_specialty) }

      before { sign_in user }

      it '別specialtyのコメントは取得できず404を返すこと' do
        delete specialty_comment_path(specialty, other_comment)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
