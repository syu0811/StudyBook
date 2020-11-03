class MyListNote < ApplicationRecord
  belongs_to :my_list
  belongs_to :note

  validates :my_list_id, presence: true, uniqueness: { scope: :note_id }
  validates :note_id, presence: true
  validates :index, presence: true, on: :update

  before_create :set_index

  class << self
    def exchange(my_list, first_id, second_id)
      first, second = my_list.my_list_notes.where(id: [first_id, second_id])
      exchange_index!(first, second)
    end

    private

    def exchange_index!(first, second)
      transaction do
        first.index, second.index = second.index, first.index
        first.save!
        second.save!
      end
      true
    rescue
      false
    end
  end

  private

  def set_index
    self.index = MyListNote.where(my_list_id: my_list_id).size
  end
end
