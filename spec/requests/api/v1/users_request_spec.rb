require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe 'GET /token' do
    # ?どういう場合に？
    context "正常時" do
      let!(:user) { create(:user) }

      it ' ステータス OK が返ってくる' do
        post api_v1_token_user_path, params: { email: user.email, password: user.password }
        expect(response).to have_http_status(:ok)
      end

      it "トークンが返ってくる" do
        post api_v1_token_user_path, params: { email: user.email, password: user.password }
        expect(response_json).to eq({ token: user.reload.token, user_id: user.reload.id })
      end
    end

    context "パスワードが違う時" do
      let!(:user) { create(:user) }

      it 'ステータス404が返ってくる' do
        post api_v1_token_user_path, params: { email: user.email, password: "not_password" }
        expect(response).to have_http_status(:not_found)
      end
    end

    context "メールアドレスが違うとき" do
      let!(:user) { create(:user) }

      it 'ActiveRecord::RecordNotFoundが発生する' do
        expect do
          post api_v1_token_user_path, params: { email: "test@example.com", password: user.password }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
