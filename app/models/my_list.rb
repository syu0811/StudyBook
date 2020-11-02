class MyList < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :my_list_notes
  has_many :notes, through: :my_list_notes
  has_many :user_subscribe_my_lists
  has_many :subscribe_users, through: :user_subscribe_my_lists, source: :users

  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 300 }

  scope :full_search, ->(query) { where('my_lists.title @@ ? OR my_lists.description @@ ?', query, query) }

  def self.regist(my_list_params, note_id)
    transaction do
      my_list = MyList.create!(my_list_params)
      my_list.my_list_notes.create!(note_id: note_id)
    end
    true
  rescue
    false
  end
end
