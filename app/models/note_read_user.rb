class NoteReadUser < ApplicationRecord
  belongs_to :note
  belongs_to :user

  validates :note_id, presence: true
  validates :user_id, presence: true, uniqueness: { scope: :note_id }

  def self.user_save(note_id, user_id)
    NoteReadUser.new(note_id: note_id, user_id: user_id).save
  end
end
