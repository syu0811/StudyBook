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

  ORDER_LIST = { "create_asc" => "created_at", "create_desc" => "created_at DESC", "update_asc" => "updated_at", "update_desc" => "updated_at DESC", "name_asc" => "title", "name_desc" => "title DESC" }.freeze

  scope :full_search, ->(query) { where('my_lists.title @@ ? OR my_lists.description @@ ?', query, query) }
  scope :trend, -> { includes(:user, :category).left_joins(:subscribe_my_lists).select('my_lists.id, my_lists.user_id, my_lists.category_id, my_lists.title, my_lists.description, my_lists.created_at, COUNT(*) as count').where("subscribe_my_lists.id IS NOT NULL").group("my_lists.id, my_lists.user_id, my_lists.category_id, my_lists.title, my_lists.description, my_lists.created_at").order("count DESC", "my_lists.id") }
  scope :specified_order, ->(sort_key) { order(sort_key.present? ? MyList::ORDER_LIST[sort_key] : MyList::ORDER_LIST["update_desc"]) }
  scope :high_light_full_search, lambda { |query|
    full_search(query)
      .select("*, pgroonga_snippet_html(my_lists.description, pgroonga_query_extract_keywords('#{query}')) AS high_light_description")
  }
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
