class MyList < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 300 }

  scope :full_search, ->(query) { where('title @@ ? OR description @@ ?', query, query) }
end
