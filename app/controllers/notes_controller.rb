class NotesController < ApplicationController
  before_action :get_note, only: [:show]
  before_action :read_user_registration, only: [:show]
  include Pagy::Backend   # Pagyを使えるようになる魔法の呪文
  ITEMS_PER_PAGE = 20
  def index
    @notes = Note.includes(:user, :category, :tags)
    @notes = @notes.where(category_id: params[:category]) if params[:category].present?
    @notes = @notes.high_light_full_search(params[:q]) if params[:q].present?
    @notes = @notes.tags_search(params[:tags]) if params[:tags].present?
    @notes = @notes.specified_order(params[:order])
    @pagy, @notes = pagy(@notes, items: ITEMS_PER_PAGE)
  end

  private

  def get_list
    @my_list_notes = MyListNote.includes(:note).where(my_list_id: params[:my_list_id]).order(:index)
  end

  def get_note
    @note = Note.includes(:user, :category, :tags).find(params[:id])
    get_list if params[:my_list_id].present?
  end

  def get_related_notes_list
    #ログインしているユーザーが見ているノートを見たことがあるユーザー一覧を取得
    @looked_users = NoteReadUser.where(note_id: params[:id])

    #取得したユーザー一覧からそのユーザーたちが見ていたノート一覧を取得
    @looked_notes = NoteReadUser.where(user_id: @looked_users.user_id)

    #さらに取得したノート一覧から同じカテゴリーのノート一覧を取得
    @related_notes = Note.includes(:user, :category, :tags).where(id: @looked_notes.note_id, category_id: @note.category_id)

    #同じカテゴリーのノート一覧からタグが一致しているノート一覧を取得
    @tags = NoteTag.where(note_id: params[:id])
    @related_notes = NoteTag.where(note_id: @related_notes.id, tag_id: @tags.tag_id)
  end

  def read_user_registration
    NoteReadUser.new(note_id: params[:id], user_id: current_user.id).save
  end
end
