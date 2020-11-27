module Users
  class NotesController < ApplicationController
    def index
      @notes = current_user.notes.includes(:tags, :category)
      @directory_tree = @notes.directory_tree
      @notes = @notes.where(category_id: params[:category]) if params[:category].present?
      @notes = @notes.where('notes.directory_path LIKE ?', "#{params[:directory_path]}%")

      sort = { "create" => "created_at DESC", "update" => "updated_at DESC", "name" => "title" }
      @notes = @notes.order(sort["update"]) if params[:order].nil?
      @notes = @notes.order(sort[params[:order]]) if params[:order].present?
    end
  end
end
