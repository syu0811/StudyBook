class Note < ApplicationRecord
  belongs_to :user
  has_many :note_tags
  has_many :tags, through: :note_tags

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :text, presence: true, length: { maximum: 30000 }
end
