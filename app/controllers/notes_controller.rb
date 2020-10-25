class NotesController < ApplicationController
  def index
    @users = current_user.id
    @notes = Note.includes(:user).where('notes.user_id = ?', @users).references(:users)
    # コピペプログラムで表示する内容をログインしているユーザーに限定することができた
  end
end
