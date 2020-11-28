class SubscribeMyList < ApplicationRecord
  belongs_to :user
  belongs_to :my_list

  validates :user_id, presence: true, uniqueness: { scope: :my_list_id }
  validates :my_list_id, presence: true
end
