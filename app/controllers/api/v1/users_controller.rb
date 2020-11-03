class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_user!
  protect_from_forgery with: :null_session

  # authenticate_with_http_token を使用するために必要
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :auth

  def token
    # トークンを発行する処理
    # メールアドレスとパスワードの受取
    @mail = params[:email]
    @password = params[:password]

    user = User.find_by(email: @mail)

    if user.valid_password?(@password)
      # 正しいときの処理
      @token = SecureRandom.urlsafe_base64(10)
      user.token = @token
      user.save
    else
      # 失敗したときの処理
      @token = "error"
    end
  end

  def auth
    # トークン認証を行う
    auth_token = params[:token]
    id = params[:id]

    user = User.find_by(id: id)

    if user.token == auth_token then
      # トークン認証に成功したパターン
      @result = "ok"
    else
      # 認証失敗
      @result = "NG"
    end

  end
end
