class NotesController < ApplicationController
  def index
    @notes = Note.includes(:user, :category)
    @notes = @notes.where(category_id: params[:category])if params[:category] != nil
  end
end
