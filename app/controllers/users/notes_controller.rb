module Users
  class NotesController < ApplicationController
    def index
      @notes = current_user.notes.includes(:tags, :category)
      @directory_tree = @notes.directory_tree
      @notes = @notes.where(category_id: params[:category]) if params[:category].present?
      @notes = @notes.where('notes.directory_path LIKE ?', "#{params[:directory_path]}%")
    end
  end
end
