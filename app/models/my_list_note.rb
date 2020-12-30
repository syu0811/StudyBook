class MyListNote < ApplicationRecord
  belongs_to :my_list
  belongs_to :note

  validates :my_list_id, presence: true, uniqueness: { scope: :note_id }
  validates :note_id, presence: true
  validates :index, presence: true, on: :update

  before_create :set_index
  before_destroy :destroy_index

  def exchange(to_index)
    return false if to_index.negative? || to_index >= MyListNote.where(my_list_id: my_list_id).size

    from_index = index
    transaction do
      to_index < from_index ? exchange_lower(from_index, to_index) : exchange_upper(from_index, to_index)
      raise ActiveRecord::Invalid unless my_list.touch
    end
    true
  rescue
    false
  end

  private

  def exchange_lower(from_index, to_index)
    MyListNote.where(my_list_id: my_list_id, index: to_index...from_index).update_all("index = index + 1")
    update!(index: to_index)
  end

  def exchange_upper(from_index, to_index)
    MyListNote.where(my_list_id: my_list_id, index: (from_index + 1)..to_index).update_all("index = index - 1")
    update!(index: to_index)
  end

  def set_index
    self.index = MyListNote.where(my_list_id: my_list_id).size
  end

  def destroy_index
    last_index = MyListNote.where(my_list_id: my_list_id).size
    return if last_index == index

    MyListNote.where(my_list_id: my_list_id, index: (index + 1)..last_index).update_all("index = index - 1")
  end
end
