module Api
  module V1
    class ApiBaseController < ApplicationController
      skip_before_action :authenticate_user!
      before_action :authenticate_token!

      def authenticate_token!
        @user = User.find(params[:user_id])
        head :bad_request unless @user.token == params[:token]
      end
    end
  end
end
