module Api
  module V1
    class ApiBaseController < ApplicationController
      skip_before_action :authenticate_user!
      before_action :authenticate_token!

      def authenticate_token!
        @agent = Agent.find_by!(guid: params[:agent_guid])
        head :bad_request unless @agent.token == params[:token]
        @user = @agent.user
      end
    end
  end
end
