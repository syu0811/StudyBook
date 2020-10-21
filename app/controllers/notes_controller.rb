class NotesController < ApplicationController
  def index

    @notes = Note.includes(:user)

    @notes.each do |nickname|
      note.user.nickname
    end

  end
end
