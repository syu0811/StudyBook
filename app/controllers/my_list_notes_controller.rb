class MyListNotesController < ApplicationController
  before_action :get_current_user_my_list, only: [:create, :destroy]

  def create
    @my_list_note = @my_list.my_list_notes.new(note_id: params[:note_id])
    if @my_list_note.save
      flash.now[:notice] = "#{@my_list.title}に追加しました"
    else
      flash.now[:danger] = 'ノートの追加に失敗しました'
    end
  end

  def destroy
    @my_list.my_list_notes.find_by!(note_id: params[:note_id]).destroy!
  end

  private

  def get_current_user_my_list
    @my_list = current_user.my_lists.find(params[:my_list_id])
  end
end
