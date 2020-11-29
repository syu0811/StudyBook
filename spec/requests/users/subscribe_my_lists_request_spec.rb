require 'rails_helper'

RSpec.describe "Users::SubscribeMyLists", type: :request do
  let(:login_user) { create(:user) }

  before do
    sign_in login_user
  end

  describe "POST /users/:user_nickname/subscribe_my_lists/:my_list_id" do
    let(:my_list) { create(:my_list, user: login_user) }

    before do
      post user_create_subscribe_my_list_path(user_nickname: login_user.nickname, my_list_id: my_list.id), xhr: true
    end

    it "リクエストが成功すること" do
      expect(response).to have_http_status(:ok)
    end

    it "購読マイリストが追加されていること" do
      expect(SubscribeMyList.all.size).to eq(1)
    end
  end

  describe "DELETE /users/:user_nickname/subscribe_my_lists/:my_list_id" do
    let(:subscribe_my_list) { create(:subscribe_my_list, user: login_user) }

    before do
      delete user_destroy_subscribe_my_list_path(user_nickname: login_user.nickname, my_list_id: subscribe_my_list.my_list_id), xhr: true
    end

    it "リクエストが成功すること" do
      expect(response).to have_http_status(:ok)
    end

    it "購読マイリストが存在しないこと" do
      expect(SubscribeMyList.all.size).to eq(0)
    end
  end
end
