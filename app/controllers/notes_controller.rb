class NotesController < ApplicationController
  before_action :get_note, only: [:show]
  def index
    @notes = Note.includes(:user, :category)
    @notes = @notes.where(category_id: params[:category]) if params[:category].present?
  end

  private

  def get_note
    @note = Note.includes(:user, :category, :tags)
    @note = Note.find(params[:id])
  end
end
