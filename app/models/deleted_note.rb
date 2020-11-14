class DeletedNote < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true

  def self.note_save(guid, user_id)
    new(guid: guid, user_id: user_id).save
  end
end
