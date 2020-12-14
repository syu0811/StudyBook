class NoteReadedUser < ApplicationRecord
  belongs_to :note
  belongs_to :user

  validates :note_id, presence: true
  validates :user_id, presence: true, uniqueness: { scope: :note_id }

  def self.get_reladed_notes_list(looking_note)
    # 今見ているノートを見たことがあるユーザーたちが見ていたノート一覧を取得
    @looked_notes = NoteReadedUser.where(user_id: NoteReadedUser.where(note_id: looking_note.id))

    # さらに取得したノート一覧から同じカテゴリーのノート一覧を取得
    @related_notes = Note.includes(:user, :category, :tags).where(id: @looked_notes.pluck(:note_id), category_id: looking_note.category_id).where.not(id: looking_note.id)

    # 同じカテゴリーのノート一覧からタグが一致しているノート一覧を取得
    @tag_notes = NoteTag.where(tag_id: NoteTag.where(note_id: looking_note.id))
    @related_notes = @related_notes.where(id: @tag_notes.pluck(:note_id)) if @tag_notes.present?
    @related_notes
  rescue  # 今見ているノートを見たことがあるユーザーが一人もいなかった場合、全体のノートをもとに関連ノートを取得する
    @related_notes = Note.includes(:user, :category, :tags).where(category_id: looking_note.category_id).where.not(id: looking_note.id)
    @tag_notes = NoteTag.where(tag_id: NoteTag.where(note_id: looking_note.id))
    @related_notes = @related_notes.where(id: @tag_notes.pluck(:note_id)) if @tag_notes.present?
    @related_notes
  end
end
