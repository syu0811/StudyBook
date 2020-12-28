module Api
  module V1
    class UsersController < ApiBaseController
      skip_before_action :authenticate_token!, only: [:token]
      protect_from_forgery with: :null_session

      def token
        # トークンを発行する処理
        @user = User.find_by!(email: params[:email])

        if @user.valid_password?(params[:password])
          # 正しいときの処理
          @token = SecureRandom.urlsafe_base64(10)
          Agent.create(user_id: @user.id, token: "test")
          # 作成したレコードのidを求め、そのレコードのトークンを変更
          max_id = Agent.maximum(:id)
          @agent = Agent.find(max_id)
          @agent.update!(token: @token)

        else # 404が帰ってきたとき（メアドがないとき)
          head :not_found
        end
      end

      def auth
        # トークン認証を行う
        # user = User.find(params[:user_id])
        user = Agent.find_by(user_id: params[:user_id])
        if user.token == params[:token]
          head :ok
        else
          head :bad_request
        end
=begin
        if user.token.blank?
          # tokenがnilのとき
          head :bad_request
        elsif user.token == params[:token]
          head :ok
        else
          head :bad_request
        end
=end
      end
    end
  end
end
