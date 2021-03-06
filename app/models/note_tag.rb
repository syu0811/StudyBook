class NoteTag < ApplicationRecord
  belongs_to :note
  belongs_to :tag

  validates :note_id, presence: true
  validates :tag_id, presence: true, uniqueness: { scope: :note_id }
end
