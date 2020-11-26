class NotesController < ApplicationController
  before_action :get_note, only: [:show]
  def index
    @notes = Note.includes(:user, :category, :tags)
    @notes = @notes.where(category_id: params[:category]) if params[:category].present?
    @notes = @notes.order(created_at: "DESC") if params[:order] == 'create'
    @notes = @notes.order(updated_at: "DESC")
  end

  private

  def get_list
    @my_list_notes = MyListNote.includes(:note).where(my_list_id: params[:my_list_id]).order(:index)
  end

  def get_note
    @note = Note.includes(:user, :category, :tags).find(params[:id])
    get_list if params[:my_list_id].present?
  end
end
