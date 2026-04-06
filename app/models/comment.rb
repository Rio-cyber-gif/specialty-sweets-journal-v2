# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :specialty

  validates :body, presence: true, length: { maximum: 1000 }
end
