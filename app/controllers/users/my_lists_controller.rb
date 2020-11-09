module Users
  class MyListsController < ApplicationController
    before_action :authenticate_user_nickname!, only: [:index]
    before_action :get_my_lists, only: [:index]

    private

    def get_my_lists
      @my_lists = MyList.includes(:category, :user).where(user: current_user)
    end
  end
end
