module Api
  module V1
    class ApiBaseController < ApplicationController
      skip_before_action :authenticate_user!
      before_action :authenticate_token!

      def authenticate_token
        user = User.find(params[:id])
        unless user.token == params[:token]
          head :bad_request
        end
      end
    end
  end
end