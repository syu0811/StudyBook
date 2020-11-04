class MyListNotesController < ApplicationController
  before_action :get_current_user_my_list, only: [:create, :update, :destroy]

  def create
    @my_list_note = @my_list.my_list_notes.new(note_id: params[:note_id])
    if @my_list_note.save
      flash.now[:notice] = "#{@my_list.title}に追加しました"
    else
      flash.now[:danger] = 'ノートの追加に失敗しました'
    end
  end

  def update
    ids = my_list_note_params
    flash.now[:danger] = 'ノートの移動に失敗しました' unless MyListNote.exchange(@my_list, ids[:first_id], ids[:second_id])
  end

  def destroy
    @my_list.my_list_notes.find_by!(note_id: params[:note_id]).destroy!
  end

  private

  def my_list_note_params
    params.require(:my_list_note).permit(:first_id, :second_id)
  end

  def get_current_user_my_list
    @my_list = current_user.my_lists.find(params[:my_list_id])
  end
end
