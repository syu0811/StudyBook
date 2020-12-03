module Admin
  class NotesController < ApplicationController
    before_action :authenticate_admin!
    before_action :get_notes, only: :index
    before_action :get_note, only: [:edit, :update, :destroy]

    def new
      @note = Note.new
    end

    def create
      @note = Note.new(note_params)
      if @note.save
        redirect_to admin_notes_path, notice: '作成に成功'
      else
        render :new
      end
    end

    def update
      if @note.update(note_params)
        redirect_to admin_notes_path, notice: '更新に成功'
      else
        render :edit
      end
    end

    def destroy
      @note.destroy!
      redirect_to admin_notes_path, notice: '削除に成功'
    end

    private

    def note_params
      params.require(:note).permit(:title, :body, :category_id, :user_id, :directory_path)
    end

    def get_notes
      @notes = Note.includes(:category, :tags, :user).all
    end

    def get_note
      @note = Note.find(params[:id])
    end
  end
end
