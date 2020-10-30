class MyListsController < ApplicationController
  before_action :get_mylists, only: [:index]
  before_action :get_mylist, only: [:show]

  private

  def get_mylists
    @my_lists = MyList.includes(:category, :user)
  end

  def get_mylist
    @my_list = MyList.includes(notes: [:user]).find(params[:id])
  end
end
