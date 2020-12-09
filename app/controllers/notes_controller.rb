class NotesController < ApplicationController
  before_action :get_note, only: [:show]
  before_action :read_user_registration, only: [:show]
  include Pagy::Backend   # Pagyを使えるようになる魔法の呪文
  ITEMS_PER_PAGE = 20
  def index
    @notes = Note.includes(:user, :category, :tags)
    @notes = @notes.where(category_id: params[:category]) if params[:category].present?
    @notes = @notes.high_light_full_search(params[:q]) if params[:q].present?
    @notes = @notes.tags_search(params[:tags]) if params[:tags].present?
    @notes = @notes.specified_order(params[:order])
    @pagy, @notes = pagy(@notes, items: ITEMS_PER_PAGE)
  end

  private

  def get_list
    @my_list_notes = MyListNote.includes(:note).where(my_list_id: params[:my_list_id]).order(:index)
  end

  def get_note
    @note = Note.includes(:user, :category, :tags).find(params[:id])
    get_list if params[:my_list_id].present?
  end

  def read_user_registration
    if NoteReadUser.regist(params[:note_id].to_i, current_user.id)
      flash.now[:notice] = '登録に成功しました'
    else
      flash.now[:danger] = '登録に失敗しました'
    end
  end
end
