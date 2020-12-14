class NoteReadedUser < ApplicationRecord
  belongs_to :note
  belongs_to :user

  validates :note_id, presence: true
  validates :user_id, presence: true, uniqueness: { scope: :note_id }

  def self.get_reladed_notes_list(looking_note)
    @looked_notes = NoteReadedUser.where(user_id: NoteReadedUser.where(note_id: looking_note.id))
    @related_notes = Note.includes(:user, :category, :tags).where(category_id: looking_note.category_id).where.not(id: looking_note.id)
    @related_notes = Note.includes(:user, :category, :tags).where(id: @looked_notes.pluck(:note_id), category_id: looking_note.category_id).where.not(id: looking_note.id) if @looked_notes.present?
    @tag_notes = NoteTag.where(tag_id: NoteTag.where(note_id: looking_note.id))
    @related_tag_notes = @related_notes.where(id: @tag_notes.pluck(:note_id)) if @tag_notes.present?
    @related_notes += @related_tag_notes if @tag_notes.present?

    @related_notes
  end
end
