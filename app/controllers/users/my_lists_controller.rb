module Users
  class MyListsController < ApplicationController
    before_action :authenticate_user_nickname!, only: [:index]
    before_action :get_my_lists, only: [:index]

    private

    def get_my_lists
      @my_lists = MyList.includes(:category, :user).where(user: current_user)
      @my_lists = @my_lists.where(category_id: params[:category]) if params[:category].present?
      @my_lists = @my_lists.specified_order(params[:order])
    end
  end
end
