require 'rails_helper'

RSpec.describe "Tops", type: :request do
  let(:login_user) { create(:user) }

  before do
    sign_in login_user
  end

  describe "/" do
    it "リクエストが成功すること" do
      get root_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "/top?select=trend_my_lists" do
    let(:my_list_a) { create(:my_list, title: "これはマイリストAです", user: login_user)}
    let(:my_list_b) { create(:my_list, title: "これはマイリストBです", user: login_user)}
    let(:subscribe_my_list) { create(:subscribe_my_list, user: login_user, my_list: my_list_a)}

    before do
      my_list_a
      my_list_b
      subscribe_my_list
    end

    context "trendのマイリストが取得できているか" do
      it "マイリストが取得できているか" do
        get root_path(select: "trend_my_lists")
        expect(response.body).to include(my_list_a.title)
      end
    end

    context "trendのマイリストに含まれてはいけないもの" do
      it "保存されていないマイリストを取得していないか" do
        get root_path(select: "trend_my_lists")
        expect(response.body).not_to include(my_list_b.title)
      end
    end
  end
end
