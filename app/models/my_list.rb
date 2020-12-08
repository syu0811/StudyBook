class MyList < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :my_list_notes, dependent: :destroy
  has_many :notes, through: :my_list_notes
  has_many :subscribe_my_lists, dependent: :destroy
  has_many :subscribe_user_my_lists, through: :subscribe_my_lists, source: :users

  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 300 }

  ORDER_LIST = { "create" => "created_at DESC", "update" => "updated_at DESC", "name" => "title" }.freeze

  scope :full_search, ->(query) { where('my_lists.title @@ ? OR my_lists.description @@ ?', query, query) }
  scope :specified_order, ->(sort_key) { order(sort_key.present? ? MyList::ORDER_LIST[sort_key] : MyList::ORDER_LIST["update"]) }

  def self.regist(my_list_params, note_id)
    transaction do
      my_list = MyList.create!(my_list_params)
      my_list.my_list_notes.create!(note_id: note_id)
    end
    true
  rescue
    false
  end

  def user_subscribe?(user_id)
    subscribe_my_lists.where(user_id: user_id).exists?
  end
end
