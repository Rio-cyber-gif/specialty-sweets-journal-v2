# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pages', type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET /terms' do
    skip 'returns http success' do
      get terms_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /privacy' do
    skip 'returns http success' do
      get privacy_path
      expect(response).to have_http_status(:success)
    end
  end
end
