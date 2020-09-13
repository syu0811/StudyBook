class UsersController < ApplicationController
  before_action :get_user, only: [:show]

  private

  def get_user
    @user = current_user
  end
end
