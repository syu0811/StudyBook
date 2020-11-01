require 'rails_helper'

RSpec.describe "MyLists", type: :request do
  describe 'ユーザでログインしている場合' do
    let(:login_user) { create(:user) }

    before do
      sign_in login_user
    end

    describe "GET /my_lists" do
      it 'ステータス OK が返ってくる' do
        get my_lists_path
        expect(response).to have_http_status(:ok)
      end
    end

    describe "GET /my_lists/:id" do
      let!(:my_list) { create(:my_list) }

      it 'ステータス OK が返ってくる' do
        get my_list_path(my_list.id)
        expect(response).to have_http_status(:ok)
      end
    end

    describe "GET /my_lists/new" do
      it 'ステータス OK が返ってくる' do
        get new_my_list_path, xhr: true
        expect(response).to have_http_status(:ok)
      end
    end

    describe "POST /my_lists" do
      let!(:category) { create(:category) }
      let!(:my_list) { build(:my_list) }

      it 'マイリスト作成に成功している' do
        post my_lists_path, params: { my_list: { title: my_list.title, description: my_list.description, category_id: category.id, user_id: login_user.id } }, xhr: true
        expect(response.body).to include("マイリスト作成に成功しました")
      end
    end
  end
end
