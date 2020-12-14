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
    get_reladed_notes_list
  end

  def get_reladed_notes_list
    @related_notes = NoteReadedUser.get_reladed_notes_list(@note)
  end

  def read_user_registration
    NoteReadedUser.new(note_id: params[:id], user_id: current_user.id).save
  end
end
