module Api
  module V1
    class MyListsController < ApiBaseController
      protect_from_forgery # これがないとCSRF対策でpostが弾かれるっぽい?
      def response_mylists
        @list = MyList.where(user_id: 1)
        @my_lists = MyList.find_by(user_id: 1)
        @my_list_notes = @my_lists.my_list_notes
      end
    end
  end
end
