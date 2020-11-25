module Api
  module V1
    class MyListsController < ApiBaseController
      protect_from_forgery # これがないとCSRF対策でpostが弾かれるっぽい?
      def response_mylists
        @my_lists = MyList.where(user_id: params[:id]).includes(notes: [:user, :tags, :my_list_notes])
      end
    end
  end
end
