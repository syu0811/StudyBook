module Users
  class MyListsController < ApplicationController
    before_action :authenticate_user_nickname!, only: [:index]
    before_action :get_my_lists, only: [:index]
    before_action :get_user_subscribe_my_list_ids, only: [:index]
    include Pagy::Backend
    ITEMS_PER_PAGE = 20

    private

    def get_my_lists
      @my_lists = MyList.includes(:category, user: { image_attachment: :blob }).where(user: current_user).or(MyList.includes(:category, user: { image_attachment: :blob }).where(id: SubscribeMyList.where(user: current_user).pluck(:my_list_id)))
      @my_lists = @my_lists.where(category_id: params[:category]) if params[:category].present?
      @my_lists = @my_lists.where(user_id: current_user.id) if params[:user] == 'true'
      @my_lists = @my_lists.high_light_full_search(params[:q]) if params[:q].present?
      @my_lists = @my_lists.specified_order(params[:order])
      @pagy, @my_lists = pagy(@my_lists, items: ITEMS_PER_PAGE)
    end

    def get_user_subscribe_my_list_ids
      @user_subscribe_my_list_ids = current_user.subscribe_my_lists.pluck(:my_list_id)
    end
  end
end
