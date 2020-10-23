class NotesController < ApplicationController
  def index
    @notes = Note.includes(:user)

    @notes.each do |_nickname|
      note.user.nickname
    end
  end
end
