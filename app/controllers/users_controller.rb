class UsersController < ApplicationController
  before_action -> { authenticate_user_nickname!(:nickname) }, only: [:show]
  before_action :get_user, only: [:show, :edit, :update]

  def update
    if @user.update(user_params)
      redirect_to user_path, notice: t('flash.update')
    else
      render :edit
    end
  end

  private

  def get_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:nickname)
  end
end
