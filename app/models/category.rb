class Category < ApplicationRecord
  has_many :my_lists
  has_many :notes

  validates :name, length: { maximum: 20 }, presence: true, uniqueness: true

  DEFAULT_CATEGORY_NAME = '未分類'.freeze

  def self.default_category
    category = find_by(name: DEFAULT_CATEGORY_NAME)
    if category
      category
    else
      logger.error("Don't exist default category!!!")
      nil
    end
  end
end
