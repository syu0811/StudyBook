module Api
  module V1
    class MyListsController < ApiBaseController
      protect_from_forgery # これがないとCSRF対策でpostが弾かれるっぽい?
      MY_LIST_INCLUDES = [{ notes: [:user, :tags, :my_list_notes] }, :subscribe_my_lists].freeze
      def index
        @my_lists = MyList.includes(MY_LIST_INCLUDES)
                          .where(user_id: @user.id)
                          .or(MyList.includes(MY_LIST_INCLUDES).where(subscribe_my_lists: { user_id: @user.id }))
      end
    end
  end
end
