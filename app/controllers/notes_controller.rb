class NotesController < ApplicationController
  def index
    @notes = Note.all
    @names = User.all
  end
end
