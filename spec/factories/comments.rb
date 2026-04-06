# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    association :user
    association :specialty
    body { 'テストコメントです' }
  end
end
