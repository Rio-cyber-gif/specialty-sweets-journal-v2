# frozen_string_literal: true

FactoryBot.define do
  factory :sweet do
    name { 'MyString' }
    description { 'MyText' }
    user { nil }
    region { nil }
    genre { nil }
  end
end
