require 'rails_helper'

RSpec.describe "Admin::Tags", type: :request do
  describe '管理者ユーザでログインしている場合' do
    let(:login_user) { create(:user, admin: true) }

    before do
      sign_in login_user
    end

    describe 'GET /admin/tags' do
      it 'ステータス OK が返ってくる' do
        get admin_tags_path
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
