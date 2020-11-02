class MyListsController < ApplicationController
  before_action :get_mylists, only: [:index]
  before_action :get_mylist, only: [:show]
  before_action :get_categories, only: [:new]

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

  private

  def my_list_params
    params.require(:my_list).permit(:title, :description, :category_id).merge(user_id: current_user.id)
  end

  def get_mylists
    @my_lists = MyList.includes(:category, :user)
  end

  def get_mylist
    @my_list = MyList.includes(notes: [:user]).find(params[:id])
  end

  def get_categories
    @categories = Category.all
  end
end
