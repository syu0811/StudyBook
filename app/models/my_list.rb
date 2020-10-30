class MyList < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :my_list_notes
  has_many :notes, through: :my_list_notes

  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 300 }

  scope :full_search, ->(query) { where('my_lists.title @@ ? OR my_lists.description @@ ?', query, query) }
end
