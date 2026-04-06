# frozen_string_literal: true

class Tag < ApplicationRecord
  has_many :specialty_tags, dependent: :destroy
  has_many :specialties, through: :specialty_tags

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 50 }
  before_save { self.name = name.downcase.strip }

  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end
end
