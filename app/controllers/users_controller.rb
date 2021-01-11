class UsersController < ApplicationController
  before_action -> { authenticate_user_nickname!(:nickname) }, only: [:show]
  before_action :get_user, only: [:show, :edit, :update]
  before_action :get_user_monthly_study_length, :get_user_monthly_create_count, :get_user_monthly_update_count, only: [:show]
  before_action :get_total_edit_word_count, only: [:show]
  before_action :get_note_count, only: [:show]
  before_action :get_my_list_count, only: [:show]

  def update
    if @user.update(user_params)
      redirect_to user_path, notice: t('flash.update')
    else
      render :edit
    end
  end

  def notes_category_ratio
    render json: current_user.notes.category_ratio
  end

  private

  def get_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:nickname, :image)
  end

  def get_user_monthly_study_length
    @user_monthly_study_length = StudyLog.new(current_user.id).user_monthly_study_length
  end

  def get_user_monthly_create_count
    @user_monthly_create_count = StudyLog.new(current_user.id).user_monthly_create_count
  end

  def get_user_monthly_update_count
    @user_monthly_update_count = StudyLog.new(current_user.id).user_monthly_update_count
  end

  def get_total_edit_word_count
    @total_edit_word_count = StudyLog.new(current_user.id).total_edit_word_count
  end

  def get_note_count
    @note_count = current_user.notes.size
  end

  def get_my_list_count
    @my_list_count = current_user.my_lists.size
  end
end
