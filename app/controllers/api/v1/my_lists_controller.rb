module Api
  module V1
    class MyListsController < ApiBaseController
      protect_from_forgery # これがないとCSRF対策でpostが弾かれるっぽい?
      def response_mylists
        @my_lists = MyList.find(params[:id])
        @my_notes = Note.find(params[:id])
      end
    end
  end
end
