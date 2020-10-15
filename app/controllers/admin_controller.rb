class AdminController < ApplicationController
  before_action :authenticate_admin!, only: [:index]

  def authenticate_admin!
    redirect_to user_path(current_user.nickname) unless current_user.admin
  end
end
