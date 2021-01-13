require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe 'GET /token' do
    context "正常時" do
      let!(:user) { create(:user) }

      it ' ステータス OK が返ってくる' do
        post api_v1_token_user_path, params: { email: user.email, password: user.password }
        expect(response).to have_http_status(:ok)
      end

      it ' トークンが返ってくる ' do
        post api_v1_token_user_path, params: { email: user.email, password: user.password }
        expect(response_json).to eq({ token: user.reload.agents.first.token, agent_guid: user.reload.agents.first.guid })
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

  describe 'GET /auth' do
    context "正常時" do
      let(:agent) { create(:agent) }

      it ' ステータス OK が返ってくる' do
        post api_v1_token_auth_path, params: { agent_guid: agent.guid, token: agent.token }
        expect(response).to have_http_status(:ok)
      end
    end

    context "guidが存在しないとき" do
      let!(:agent) { create(:agent) }

      it 'ActiveRecord::RecordNotFoundが発生する' do
        expect do
          post api_v1_token_auth_path, params: { agent_guid: 2000, token: agent.token }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "tokenが間違っているとき" do
      let!(:agent) { create(:agent) }

      it 'ステータス404が返ってくる' do
        post api_v1_token_auth_path, params: { agent_guid: agent.guid, token: "testtoken" }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "tokenが登録されていないとき" do
      let(:agent) { create(:agent) }

      it 'ステータス404が返ってくる' do
        post api_v1_token_auth_path, params: { agent_guid: agent.guid, token: nil }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
