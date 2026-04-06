# frozen_string_literal: true

class Region < ApplicationRecord
  has_many :specialties, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
end
