class Note < ApplicationRecord
  belongs_to :user

  has_many :my_list_notes
  has_many :my_lists, through: :my_list_notes

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :text, presence: true, length: { maximum: 30000 }
end
