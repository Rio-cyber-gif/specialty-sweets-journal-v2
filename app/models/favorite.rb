# frozen_string_literal: true

class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :specialty

  validates :user_id, uniqueness: { scope: :specialty_id }
end
