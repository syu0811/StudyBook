class NoteReadedUser < ApplicationRecord
  belongs_to :note
  belongs_to :user

  validates :note_id, presence: true
  validates :user_id, presence: true, uniqueness: { scope: :note_id }

  def self.get_reladed_notes_list(looking_note)
    # ログインしているユーザーが見ているノートを見たことがあるユーザー一覧を取得
    @looked_users = NoteReadedUser.where(note_id: note_id)

    # 取得したユーザー一覧からそのユーザーたちが見ていたノート一覧を取得
    @looked_notes = NoteReadedUser.where(user_id: @looked_users.pluck(:user_id))

    # さらに取得したノート一覧から同じカテゴリーのノート一覧を取得
    @related_notes = Note.includes(:user, :category, :tags).where(id: @looked_notes.pluck(:note_id), category_id: looking_note.category_id).where.not(id: looking_note.id)

    # 同じカテゴリーのノート一覧からタグが一致しているノート一覧を取得
    @tag_notes = NoteTag.where(note_id: looking_note.id)
    if @tag_notes.present?  # tagが一致しているノートがあったら
      @tag_notes = NoteTag.where(tag_id: @tag_notes.pluck(:tag_id))
      @related_notes = @related_notes.where(id: @tag_notes.pluck(:note_id))
    end
    @related_notes
  rescue
    @related_notes = Note.includes(:user, :category, :tags).where(category_id: looking_note.category_id).where.not(id: looking_note.id)
    @tag_notes = NoteTag.where(note_id: looking_note.id)
    if @tag_notes.present?
      @tag_notes = NoteTag.where(tag_id: @tag_notes.pluck(:tag_id))
      @related_notes = @related_notes.where(id: @tag_notes.pluck(:note_id))
    end
    @related_notes
  end
end
