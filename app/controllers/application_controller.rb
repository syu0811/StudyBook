class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  add_flash_types :success, :info, :warning, :danger

  def authenticate_user_nickname!
    head :not_found unless params[:nickname] == current_user.nickname
  end

  def authenticate_admin!
    redirect_to user_path(current_user.nickname) unless current_user.admin
  end
end
