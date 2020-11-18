module Users
  class NotesController < ApplicationController
    def index
      @notes = current_user.notes.includes(:tags, :category)
      @directory_tree = @notes.directory_tree
      @notes = @notes.where(category_id: params[:category]) if params[:category].present?
      @notes = @notes.where('notes.file_path LIKE ?', "#{params[:file_path]}%")
    end
  end
end
