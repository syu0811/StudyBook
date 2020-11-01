class MyListsController < ApplicationController
  before_action :get_mylists, only: [:index]
  before_action :get_mylist, only: [:show]
  before_action :get_categories, only: [:new]

  def new
    # マイリスト一覧と、新規登録のためのviewを返す。（ポップアップで表示する画面）
    @my_list = MyList.new
  end

  def create
    # 登録する。
    @my_list = MyList.new(my_list_params)
    if @my_list.save
      flash.now[:notice] = 'マイリスト作成に成功しました'
    else
      flash.now[:danger] = 'マイリスト作成に失敗しました'
      p @my_list.errors
    end
  end

  def update
    # 新規にマイリストに追加する
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
