class Tag < ApplicationRecord
  has_many :note_tags, dependent: :destroy
  has_many :notes, through: :note_tags
  validates :name, presence: true, uniqueness: true, length: { maximum: 20 }
end
