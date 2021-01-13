class ApplicationController < ActionController::Base
  before_action :store_location
  before_action :authenticate_user!
  add_flash_types :success, :info, :warning, :danger

  def store_location
    if request.fullpath != "/users/sign_in" &&
       request.fullpath != "/users/sign_up" &&
       request.fullpath != "/users/sign_out" &&
       request.fullpath !~ Regexp.new("\\A/users/password.*\\z") &&
       !request.xhr?
      session[:previous_url] = request.fullpath
    end
  end

  def authenticate_user_nickname!(params_sym = :user_nickname)
    head :not_found unless params[params_sym] == current_user.nickname
  end

  def authenticate_admin!
    redirect_to user_path(current_user.nickname) unless current_user.admin
  end

  def query_params
    params.permit(:category, :order, :page, :user)
  end
end
