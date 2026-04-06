# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # アソシエーション（関連付け）
  has_many :specialties, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_specialties, through: :favorites, source: :specialty

  has_one_attached :avatar

  # バリデーション
  validates :name, presence: true, length: { maximum: 50 }
  validates :bio, length: { maximum: 300 }, allow_blank: true

  # enum（権限の定義）
  enum :role, { general: 0, admin: 1 }
end
