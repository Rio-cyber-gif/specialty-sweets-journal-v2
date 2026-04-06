# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'バリデーション' do
    let(:comment) { build(:comment) }

    it '有効なコメントは保存できること' do
      expect(comment).to be_valid
    end

    it 'bodyが空の場合は無効であること' do
      comment.body = ''
      expect(comment).not_to be_valid
      expect(comment.errors[:body]).to be_present
    end

    it 'bodyがnilの場合は無効であること' do
      comment.body = nil
      expect(comment).not_to be_valid
    end

    it 'bodyが1000文字以内なら有効であること' do
      comment.body = 'a' * 1000
      expect(comment).to be_valid
    end

    it 'bodyが1001文字以上の場合は無効であること' do
      comment.body = 'a' * 1001
      expect(comment).not_to be_valid
      expect(comment.errors[:body]).to be_present
    end

    it 'userが必須であること' do
      comment.user = nil
      expect(comment).not_to be_valid
    end

    it 'specialtyが必須であること' do
      comment.specialty = nil
      expect(comment).not_to be_valid
    end
  end

  describe 'アソシエーション' do
    it 'userに属すること' do
      comment = build(:comment)
      expect(comment.user).to be_a(User)
    end

    it 'specialtyに属すること' do
      comment = build(:comment)
      expect(comment.specialty).to be_a(Specialty)
    end
  end
end
