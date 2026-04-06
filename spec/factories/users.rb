# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" } # ← 連番で一意なメールアドレスを生成
    sequence(:name) { |n| "ユーザー#{n}" } # nameカラムがあれば追加
    password { 'password' }
    password_confirmation { 'password' }
  end
end
