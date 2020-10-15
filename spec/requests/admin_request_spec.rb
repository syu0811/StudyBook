require 'rails_helper'

RSpec.describe "Admins", type: :request do
  describe '管理者ユーザでログインしている場合' do
    let(:login_user) { create(:user, admin: true) }

    before do
      sign_in login_user
    end

    describe 'GET /admin' do
      it 'ステータス OK が返ってくる' do
        get admin_index_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe '一般者ユーザでログインしている場合' do
    let(:login_user) { create(:user, admin: false) }

    before do
      sign_in login_user
    end

    describe 'GET /admin' do
      it '一覧ページへリダイレクトすること' do
        get admin_index_path
        expect(response).to redirect_to user_path(login_user.nickname)
      end
    end
  end
end
