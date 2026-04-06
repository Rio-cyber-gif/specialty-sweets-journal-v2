# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sweets', type: :request do
  # ログイン用のユーザーを作成
  let(:user) { create(:user) }

  before do
    # テスト実行前にログイン
    sign_in user
  end

  describe 'GET /new' do
    skip '新規投稿ページが表示されること' do
      get '/sweets/new'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create' do
    let(:genre) { create(:genre) }
    let(:region) { create(:region) }

    skip 'returns http redirect' do
      post '/sweets', params: {
        sweet: {
          name: 'テスト銘菓',
          description: 'テスト説明',
          genre_id: genre.id,
          region_id: region.id
        }
      }
      expect(response).to have_http_status(:redirect)
    end
  end
end
