class NotesController < ApplicationController
  include Pagy::Backend   # Pagyを使えるようになる魔法の呪文
  ITEMS_PER_PAGE = 20
  before_action :get_note, only: [:show]
  before_action :get_list, only: [:show]
  before_action :get_reladed_notes_list, only: [:show]
  before_action :write_read_note_log, only: [:show]

  def index
    @notes = Note.includes(:category, :tags, user: { image_attachment: :blob })
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
    get_reladed_notes_list
  end

  def get_reladed_notes_list
    @related_notes = Note.get_reladed_notes_list(@note)
  end

  def write_read_note_log
    return if @note.user_id == current_user.id

    ReadNoteLog.new(current_user.id).write_read_note_log([{ note_id: @note.id }])
  end
end
