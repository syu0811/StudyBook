class Category < ApplicationRecord
  has_many :my_lists
  has_many :notes

  validates :name, length: { maximum: 20 }, presence: true, uniqueness: true
end
