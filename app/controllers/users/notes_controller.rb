module Users
  class NotesController < ApplicationController
    include Pagy::Backend
    ITEMS_PER_PAGE = 20

    def index
      @notes = current_user.notes.includes(:tags, :category, user: { image_attachment: :blob })
      @directory_tree = @notes.directory_tree
      @notes = @notes.where(category_id: params[:category]) if params[:category].present?
      @notes = @notes.where('notes.directory_path LIKE ?', "#{params[:directory_path]}%")
      @notes = @notes.high_light_full_search(params[:q]) if params[:q].present?
      @notes = @notes.tags_search(params[:tags]) if params[:tags].present?
      @notes = @notes.specified_order(params[:order])
      @pagy, @notes = pagy(@notes, items: ITEMS_PER_PAGE, link_extra: 'data-remote="true"')
    end
  end
end
