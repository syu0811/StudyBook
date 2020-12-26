class MyListsController < ApplicationController
  before_action :get_my_lists, only: [:index]
  before_action :get_current_user_my_list, only: [:edit, :update, :destroy]
  before_action :get_categories, only: [:new, :edit]
  before_action :get_user_subscribe_my_list_ids, only: [:index]
  include Pagy::Backend
  ITEMS_PER_PAGE = 20

  def show
    @my_list = MyList.find(params[:id])
    @my_list_notes = @my_list.my_list_notes.includes(note: [:tags, :category, { user: { image_attachment: :blob } }]).order("my_list_notes.index")
  end

  def new
    @my_list = MyList.new
    @my_lists = current_user.my_lists.includes(:my_list_notes)
  end

  def create
    if MyList.regist(my_list_params, params[:note_id])
      flash.now[:notice] = 'マイリスト作成に成功しました'
    else
      flash.now[:danger] = 'マイリスト作成に失敗しました'
    end
  end

  def update
    if @my_list.update(my_list_params)
      flash.now[:notice] = 'マイリスト情報を更新しました'
    else
      flash.now[:danger] = 'マイリスト情報更新に失敗しました'
      get_current_user_my_list
    end
  end

  def destroy
    if @my_list.destroy
      flash.now[:notice] = 'マイリストを削除しました'
    else
      flash.now[:danger] = 'マイリストの削除に失敗しました'
    end

    if params[:redirect_to_user_my_lists] == 'true'
      redirect_to user_my_lists_path(current_user.nickname, query_params)
    else
      redirect_to my_lists_path(query_params)
    end
  end

  private

  def my_list_params
    params.require(:my_list).permit(:title, :description, :category_id).merge(user_id: current_user.id)
  end

  def get_my_lists
    @my_lists = MyList.includes(:category, user: { image_attachment: :blob })
    @my_lists = @my_lists.where(category_id: params[:category]) if params[:category].present?
    @my_lists = @my_lists.high_light_full_search(params[:q]) if params[:q].present?
    @my_lists = @my_lists.specified_order(params[:order])
    @pagy, @my_lists = pagy(@my_lists, items: ITEMS_PER_PAGE)
  end

  def get_current_user_my_list
    @my_list = current_user.my_lists.find(params[:id])
  end

  def get_categories
    @categories = Category.all
  end

  def get_user_subscribe_my_list_ids
    @user_subscribe_my_list_ids = current_user.subscribe_my_lists.pluck(:my_list_id)
  end
end
