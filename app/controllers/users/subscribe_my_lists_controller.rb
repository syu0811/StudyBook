module Users
  class SubscribeMyListsController < ApplicationController
    before_action :authenticate_user_nickname!
    def create
      @user_subscribe_my_list = current_user.subscribe_my_lists.new(my_list_id: params[:my_list_id])
      if @user_subscribe_my_list.save
        flash.now[:notice] = 'マイリストを登録しました'
      else
        flash.now[:danger] = 'マイリストの登録に失敗しました'
      end
    end

    def destroy
      @user_subscribe_my_list = current_user.subscribe_my_lists.find_by!(my_list_id: params[:my_list_id])
      if @user_subscribe_my_list.destroy
        flash.now[:notice] = 'マイリストを削除しました'
      else
        flash.now[:danger] = 'マイリストの削除に失敗しました'
      end
    end
  end
end
