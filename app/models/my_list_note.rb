class MyListNote < ApplicationRecord
  belongs_to :my_list
  belongs_to :note

  validates :my_list_id, presence: true, uniqueness: { scope: :note_id }
  validates :note_id, presence: true
end
