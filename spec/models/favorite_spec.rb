# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Favorite, type: :model do
  describe 'バリデーション' do
    let(:user) { create(:user) }
    let(:specialty) { create(:specialty) }

    it '有効なお気に入りは保存できること' do
      favorite = build(:favorite, user: user, specialty: specialty)
      expect(favorite).to be_valid
    end

    it '同一ユーザーが同一specialtyに重複登録できないこと' do
      create(:favorite, user: user, specialty: specialty)
      duplicate = build(:favorite, user: user, specialty: specialty)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:user_id]).to be_present
    end

    it '別のユーザーが同一specialtyにお気に入り登録できること' do
      other_user = create(:user)
      create(:favorite, user: user, specialty: specialty)
      another_favorite = build(:favorite, user: other_user, specialty: specialty)
      expect(another_favorite).to be_valid
    end

    it '同一ユーザーが別のspecialtyにお気に入り登録できること' do
      other_specialty = create(:specialty)
      create(:favorite, user: user, specialty: specialty)
      another_favorite = build(:favorite, user: user, specialty: other_specialty)
      expect(another_favorite).to be_valid
    end
  end

  describe 'アソシエーション' do
    it 'userに属すること' do
      favorite = build(:favorite)
      expect(favorite.user).to be_a(User)
    end

    it 'specialtyに属すること' do
      favorite = build(:favorite)
      expect(favorite.specialty).to be_a(Specialty)
    end
  end
end
