class MyListsController < ApplicationController
  before_action :get_mylists, only: [:index]

  private

  def get_mylists
    @my_lists = MyList.includes(:category, :user)
  end
end
