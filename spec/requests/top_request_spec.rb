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
    limit = 30
    let(:my_lists) { create_list(:my_list, limit + 1, user: login_user) }

    before do
      my_lists.each do |my_list|
        create(:subscribe_my_list, my_list: my_list, user: login_user)
      end
    end

    it "マイリストが取得できているか" do
      get root_path(select: "trend_my_lists")
      expect(response.body).to include(my_lists[0].title)
    end

    it "取得件数が上限数で収まっているか" do
      get root_path(select: "trend_my_lists")
      expect(response.body).not_to include(my_lists[limit].title)
    end
  end
end
