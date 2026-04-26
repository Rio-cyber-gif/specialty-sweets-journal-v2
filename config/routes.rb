# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    root 'dashboard#index' # 管理画面のトップページ
    resources :users, only: %i[index edit update destroy]
    resources :specialties, only: %i[index edit update destroy]
  end
  # Devise（ユーザー認証）
  devise_for :users, controllers: { registrations: 'users/registrations' }

  # ルートページ
  root 'home#index'

  # Specialties（銘菓）の全アクション
  resources :specialties do
    resources :comments, only: %i[create destroy]
    resource :favorite, only: %i[create destroy]
  end

  # 地域別ページ
  resources :regions, only: [:show]

  # 地方ブロック別ページ
  get 'region_blocks/:block', to: 'region_blocks#show', as: :region_block_page

  # マイページ
  get 'mypage', to: 'users#mypage', as: :mypage

  # プロフィール更新（アイコン・名前・自己紹介）
  patch 'users/profile', to: 'users#update_profile', as: :update_user_profile

  # 公開プロフィール
  get 'users/:id', to: 'users#show', as: :user_profile

  # 静的ページ
  get 'terms', to: 'pages#terms'
  get 'privacy', to: 'pages#privacy'
  get 'guide', to: 'pages#guide', as: :guide

  # ヘルスチェック（本番環境で必要な場合）
  # get "up" => "rails/health#show", as: :rails_health_check

  # PWA機能（Progressive Web App用）
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
