module Api
  module V1
    class MyListsController < ApiBaseController
      protect_from_forgery # これがないとCSRF対策でpostが弾かれるっぽい?
      def response_mylists
        if authenticate_token!() != :bad_request
          @userdata = MyList.find(params[:id])
          @category = @userdata.category_id
        end
      end
    end
  end
end