class AdminController < ApplicationController
  before_action :authenticate_admin!, only: [:index]
end
