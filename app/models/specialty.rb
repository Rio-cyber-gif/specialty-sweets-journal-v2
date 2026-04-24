# frozen_string_literal: true

class Specialty < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :region
  has_one_attached :image
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :specialty_tags, dependent: :destroy
  has_many :tags, through: :specialty_tags

  def tag_list
    tags.map(&:name).join(', ')
  end

  def tag_list=(names_str)
    self.tags = names_str.to_s.split(',').map(&:strip).compact_blank.uniq.map do |name|
      Tag.find_or_create_by!(name: name.downcase.strip)
    end
  end

  def favorited_by?(user)
    return false unless user

    favorites.exists?(user_id: user.id)
  end

  enum :status, { published: 0, draft: 1 }

  scope :publicly_visible, -> { published }

  validates :name, presence: true, length: { maximum: 100 }

  validate :image_type_and_size, if: -> { image.attached? }

  def self.ransackable_attributes(_auth_object = nil)
    %w[name region_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[region tags]
  end

  private

  def image_type_and_size
    # content_typeのチェック
    errors.add(:image, 'はPNG、JPG、JPEG形式のみアップロードできます') unless image.content_type.in?(%w[image/png image/jpeg image/jpg])

    return unless image.blob.byte_size > 5.megabytes

    errors.add(:image, 'は5MB以下にしてください')
  end
end
