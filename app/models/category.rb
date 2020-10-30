class Category < ApplicationRecord
  has_many :my_lists

  validates :name, length: { maximum: 20 }, presence: true, uniqueness: true
end
