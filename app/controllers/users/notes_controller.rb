module Users
  class NotesController < ApplicationController
    def index
      @notes = current_user.notes
    end
  end
end
