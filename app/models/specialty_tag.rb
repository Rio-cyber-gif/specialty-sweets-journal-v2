# frozen_string_literal: true

class SpecialtyTag < ApplicationRecord
  belongs_to :specialty
  belongs_to :tag

  validates :tag_id, uniqueness: { scope: :specialty_id,
                                   message: 'このタグはすでに登録されています' }
end
