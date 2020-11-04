class MyListsController < ApplicationController
  before_action :get_my_lists, only: [:index]
  before_action :get_current_user_my_list, only: [:edit, :update]
  before_action :get_categories, only: [:new, :edit]

  def show
    @my_list = MyList.find(params[:id])
    @notes = @my_list.notes.includes(:user, :my_list_notes).order("my_list_notes.index")
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
    end
  end

  private

  def my_list_params
    params.require(:my_list).permit(:title, :description, :category_id).merge(user_id: current_user.id)
  end

  def get_my_lists
    @my_lists = MyList.includes(:category, :user)
  end

  def get_current_user_my_list
    @my_list = current_user.my_lists.find(params[:id])
  end

  def get_categories
    @categories = Category.all
  end
end
