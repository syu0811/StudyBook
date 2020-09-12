class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  add_flash_types :success, :info, :warning, :danger
end
