class NoteReadUser < ApplicationRecord
  belongs_to :note
  belongs_to :user

  validates :note_id, presence: true
  validates :user_id, presence: true, uniqueness: { scope: :note_id }

  def self.get_related_notes_list(note_id)
    @looking_note = Note.includes(:user, :category, :tags).find(note_id)
    begin
      # ログインしているユーザーが見ているノートを見たことがあるユーザー一覧を取得
      @looked_users = NoteReadUser.where(note_id: note_id)

      # 取得したユーザー一覧からそのユーザーたちが見ていたノート一覧を取得
      @looked_notes = NoteReadUser.where(user_id: @looked_users.user_id)

      # さらに取得したノート一覧から同じカテゴリーのノート一覧を取得
      @related_notes = Note.includes(:user, :category, :tags).where(id: @looked_notes.note_id, category_id: @looking_note.category_id).where.not(id: note_id)

      # 同じカテゴリーのノート一覧からタグが一致しているノート一覧を取得
      @tag_notes = NoteTag.where(note_id: note_id)
      if @tag_notes.present?  # tagが一致しているノートがあったら
        @tag_notes = NoteTag.where(tag_id: @tag_notes.tag_id)
        @related_notes = @related_notes.where(id: @tag_notes.note_id)
      end
    rescue
      @related_notes = Note.includes(:user, :category, :tags).where(category_id: @looking_note.category_id).where.not(id: note_id)
      @tag_notes = NoteTag.where(note_id: note_id)
      if @tag_notes.present?
        @tag_notes = NoteTag.where(tag_id: @tag_notes.tag_id)
        @related_notes = @related_notes.where(id: @tag_notes.note_id)
      end
    end
  end
end
