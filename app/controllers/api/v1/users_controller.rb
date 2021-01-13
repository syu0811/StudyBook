module Api
  module V1
    class UsersController < ApiBaseController
      skip_before_action :authenticate_token!, only: [:token]
      protect_from_forgery with: :null_session

      def token
        @user = User.find_by!(email: params[:email])

        if @user.valid_password?(params[:password])
          @token = SecureRandom.urlsafe_base64(10)
          @agent = Agent.create(user_id: @user.id, token: @token)
        else
          head :not_found
        end
      end

      def auth
        user = Agent.find_by!(guid: params[:agent_guid])
        if user.token == params[:token]
          head :ok
        else
          head :bad_request
        end
      end
    end
  end
end
