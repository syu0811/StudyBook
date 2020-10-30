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
      let(:my_list) { create(:my_list) }

      before do
        my_list
      end

      it 'ステータス OK が返ってくる' do
        get my_list_path(my_list.id)
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
