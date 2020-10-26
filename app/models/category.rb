class Category < ApplicationRecord
  validates :name, length: { maximum: 20 }, presence: true, uniqueness: true
end
