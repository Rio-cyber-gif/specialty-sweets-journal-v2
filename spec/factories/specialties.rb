# frozen_string_literal: true

FactoryBot.define do
  factory :specialty do
    association :user
    association :region
    sequence(:name) { |n| "銘菓#{n}" }
    description { 'テスト銘菓の説明文' }
  end
end
