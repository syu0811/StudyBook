class NoteReadUser < ApplicationRecord
  belongs_to :note
  belongs_to :user

  validates :note_id, presence: true
  validates :user_id, presence: true, uniqueness: { scope: :note_id }

  def self.regist(note_id, user_id)
    transaction do
      NoteReadUser.create!(note_id: note_id, user_id: user_id)
    end
    true
  rescue
    false
  end
end
