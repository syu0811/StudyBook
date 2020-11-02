class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_user!
  protect_from_forgery with: :null_session
  def token # user/tokenにアクセスされたら来る
    # メールアドレスとパスワードの受取
    @mail = params[:email]
    @password = params[:password]
    # @mail = "general@example.com"
    # @password = "password"

    # DBから登録されたパスワードを受け取る
    user = User.find_by(email: @mail) # メールアドレスに紐付いたユーザー情報を受け取る

    if user.valid_password?(@password) then
      # 正しいときの処理
      # トークン生成
      @token = SecureRandom.urlsafe_base64(10)
      user.token = @token
      user.save
    else
      # 失敗したときの処理
      @token = "error"
    end
  end
end
