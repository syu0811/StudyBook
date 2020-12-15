class NoteReadedUser < ApplicationRecord
  belongs_to :note
  belongs_to :user

  validates :note_id, presence: true
  validates :user_id, presence: true, uniqueness: { scope: :note_id }

  def self.get_reladed_notes_list(looking_note)
    @looked_notes = NoteReadedUser.where(user_id: NoteReadedUser.where(note_id: looking_note.id).pluck(:user_id))
    @related_notes = Note.includes(:user, :category, :tags).where(category_id: looking_note.category_id).where.not(id: looking_note.id)
    @related_notes = Note.includes(:user, :category, :tags).where(id: @looked_notes.pluck(:note_id), category_id: looking_note.category_id).where.not(id: looking_note.id) if @looked_notes.present?

    @tag_notes = NoteTag.where(tag_id: NoteTag.where(note_id: looking_note.id).pluck(:tag_id))
    if @tag_notes.present?
      @related_notes = @related_notes.where(id: @tag_notes.pluck(:note_id))
      @related_notes = @related_notes.select('note_tags.note_id', 'notes.title', 'note_tags.tag_id', 'COUNT(*) AS count')
                                     .joins(:note_tags).group('id', 'title', 'tag_id').order("count DESC")
    end

    # SELECT Note.id, title, tag_id, COUNT(*) as count
    # FROM Note JOIN NoteTag ON Note.id = NoteTag.note_id
    # GROUP BY id, title, tag_id
    # ORDER BY count DESC

    @related_notes
  end
end
