require 'rails_helper'

RSpec.describe "Admin::Categories", type: :request do
  describe '管理者ユーザでログインしている場合' do
    let(:login_user) { create(:user, admin: true) }

    before do
      sign_in login_user
    end

    describe 'GET /admin/categories' do
      it 'ステータス OK が返ってくる' do
        get admin_categories_path
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'GET /admin/categories/new' do
      it 'ステータス OK が返ってくる' do
        get new_admin_category_path
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'POST /admin/categories' do
      context '正常系' do
        let(:category) { build(:category) }

        it '一覧ページへリダイレクトすること' do
          post admin_categories_path, params: { category: { name: category.name } }
          expect(response).to redirect_to admin_categories_path
        end
      end

      context '異常系' do
        let(:category) { build(:category, name: nil) }

        it '登録に失敗し遷移しない' do
          post admin_categories_path, params: { category: { name: category.name } }
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end

  describe '一般者ユーザでログインしている場合' do
    let(:login_user) { create(:user, admin: false) }

    before do
      sign_in login_user
    end

    describe 'GET /admin/categories' do
      it 'ユーザページへリダイレクトすること' do
        get admin_categories_path
        expect(response).to redirect_to user_path(login_user.nickname)
      end
    end

    describe 'GET /admin/categories/new' do
      it 'ユーザページへリダイレクトすること' do
        get new_admin_category_path
        expect(response).to redirect_to user_path(login_user.nickname)
      end
    end

    describe 'POST /admin/categories' do
      let(:category) { build(:category) }

      it 'ユーザページへリダイレクトすること' do
        post admin_categories_path, params: { category: { name: category.name } }
        expect(response).to redirect_to user_path(login_user.nickname)
      end
    end
  end
end
