class NotesController < ApplicationController
  before_action :get_note, only: [:show]
  def index
    @notes = Note.includes(:user, :category)
    @notes = @notes.where(category_id: params[:category]) if params[:category].present?
  end

  private

  def get_list
    @my_list_notes = MyListNote.joins(:note).select("my_list_notes.*, notes.*")
    @my_list_notes = @my_list_notes.where(my_list_id: params[:my_list_id]).order(index: "ASC")
    @note = @my_list_notes.find_by(index: params[:index])
  end

  def get_note
    @note = Note.includes(:user, :category, :tags).find(params[:id])
    get_list if params[:my_list_id].present?
  end
end
