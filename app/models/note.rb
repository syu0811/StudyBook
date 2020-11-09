class Note < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :note_tags
  has_many :tags, through: :note_tags

  has_many :my_list_notes
  has_many :my_lists, through: :my_list_notes

  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :text, presence: true, length: { maximum: 30000 }
  validates :file_path, length: { maximum: 255 }

  before_create :add_uuid

  def add_uuid
    self.guid = SecureRandom.uuid
  end
end
