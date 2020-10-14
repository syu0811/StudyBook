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

    describe 'GET /admin/tags/new' do
      it 'ステータス OK が返ってくる' do
        get new_admin_tag_path
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'POST /admin/tags' do
      context '正常系' do
        let(:tag) { build(:tag) }

        it '一覧ページへリダイレクトすること' do
          post admin_tags_path, params: { tag: { name: tag.name } }
          expect(response).to redirect_to admin_tags_path
        end
      end

      context '異常系' do
        let(:tag) { build(:tag, name: nil) }

        it '登録に失敗し遷移しない' do
          post admin_tags_path, params: { tag: { name: tag.name } }
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end
end
