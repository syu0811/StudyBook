module Users
  class NotesController < ApplicationController
    include Pagy::Backend
    ITEMS_PER_PAGE = 20

    def index
      @notes = current_user.notes.includes(:tags, :category, user: { image_attachment: :blob })
      @directory_tree = @notes.directory_tree
      @notes = @notes.where(category_id: params[:category]) if params[:category].present?
      @notes = @notes.where('notes.directory_path LIKE ?', "#{params[:directory_path]}%")
      @notes = @notes.specified_order(params[:order])
      @pagy, @notes = pagy(@notes, items: ITEMS_PER_PAGE)
    end
  end
end
