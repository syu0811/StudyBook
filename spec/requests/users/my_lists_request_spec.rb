require 'rails_helper'

RSpec.describe "Users::MyLists", type: :request do
  describe 'ユーザでログインしている場合' do
    let(:login_user) { create(:user) }

    before do
      sign_in login_user
    end

    describe "GET users/:user_nickname/my_lists" do
      let(:my_list) { create(:my_list) }

      before do
        my_list
      end

      it 'ステータス OK が返ってくる' do
        get user_my_lists_path(user_nickname: login_user.nickname)
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
