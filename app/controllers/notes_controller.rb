class NotesController < ApplicationController
  def index
    @notes = Note.includes(:user)
  end
end
