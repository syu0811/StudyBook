class TopController < ApplicationController
  NUMBER_OF_NEW_NOTES = 50

  def index
    @new_notes = Note.includes(:user, :tags, :category)
    @new_notes = @new_notes.order(created_at: "DESC").limit(NUMBER_OF_NEW_NOTES)
  end
end
