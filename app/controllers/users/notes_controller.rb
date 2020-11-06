module Users
	class NotesController < ApplicationController
		def index
  	  @notes = Note.includes(:user)
  	  @notes = @notes.where(user_id: current_user.id)
  	end
	end
end
