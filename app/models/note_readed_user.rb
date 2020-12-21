class NoteReadedUser < ApplicationRecord
  belongs_to :note
  belongs_to :user

  validates :note_id, presence: true
  validates :user_id, presence: true, uniqueness: { scope: :note_id }

  def self.get_reladed_notes_list(looking_note)
    # ノートをみたユーザのみたノートid一覧
    looked_note_ids = NoteReadedUser.where(user_id: NoteReadedUser.where(note_id: looking_note.id).pluck(:user_id)).pluck(:note_id)
    looked_note_ids.delete(looking_note.id)

    if looked_note_ids.empty?
      # タグ一致数多いものでソート？
      return Note.includes(:user, :category, :tags).where(category_id: looking_note.category_id).where.not(id: looking_note.id)
    end
    # 自分自身を削除
    # タグでORDER タグが1つでも一致してないと、消えてしまう。 カテゴリーが現在のものと一致するものだけに。
    note_tags = NoteTag.left_joins(:note).select('notes.id', 'notes.user_id', 'notes.category_id', 'COUNT(*) as count').where(notes: { id: looked_note_ids, category_id: looking_note.category_id }).group('notes.id', 'notes.user_id', 'notes.category_id').order('count DESC')
    # note = Note.joins("RIGHT JOIN note_tags ON notes.id = note_tags.note_id").joins(:user, :category, :tags)
    # note = Note.left_joins(:user, :category, :tags).joins("RIGHT JOIN note_tags ON notes.id = note_tags.note_id")
    # 再取得（include付き)
    if note_tags.empty?
      # ノートを見てるユーザが存在しない場合と、タグが一致しているノートが存在しない場合
      return Note.includes(:user, :category, :tags).where(category_id: looking_note.category_id).where.not(id: looking_note.id)
    end

    return note_tags
  end
end
