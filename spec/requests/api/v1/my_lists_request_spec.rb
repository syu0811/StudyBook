require 'rails_helper'

RSpec.describe "Api::V1::MyLists", type: :request do
  describe 'GET /response_mylists' do
    context "正常時" do
      let!(:user) { create(:user) }

      it ' ステータス OK が返ってくる' do
        get api_v1_my_lists_response_mylists_path, params: { id: user.id, token: user.token }
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
