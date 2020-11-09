require 'rails_helper'

RSpec.describe "Admin::Categories", type: :request do
  describe '管理者ユーザでログインしている場合' do
    let(:login_user) { create(:user, admin: true) }

    before do
      sign_in login_user
    end

    describe 'GET /admin/categories' do
      let!(:categories) { create_list(:category, 2) }

      it 'ステータス OK が返ってくる' do
        get admin_categories_path
        expect(response).to have_http_status(:ok)
      end

      it "一覧のデータ生成の成功" do
        get admin_categories_path
        expect(response.body).to include(categories[0].name, categories[1].name)
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

    describe 'GET /admin/categories/:id/edit' do
      let(:category) { create(:category) }

      before do
        category
      end

      it 'ステータス OK が返ってくる' do
        get edit_admin_category_path(category.id)
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'PUT /admin/categories/:id' do
      let(:category) { create(:category) }

      before do
        category
      end

      context '正常系' do
        it '一覧ページへリダイレクトすること' do
          put admin_category_path(category.id), params: { category: { name: category.name } }
          expect(response).to redirect_to admin_categories_path
        end
      end

      context '異常系' do
        it '登録に失敗し遷移しない' do
          put admin_category_path(category.id), params: { category: { name: '' } }
          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe 'DELETE /admin/categories/:id' do
      let(:category) { create(:category) }

      before do
        category
      end

      it '一覧ページへリダイレクトすること' do
        delete admin_category_path(category.id)
        expect(response).to redirect_to admin_categories_path
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

    describe 'GET /admin/categories/:id/edit' do
      let(:category) { create(:category) }

      before do
        category
      end

      it 'ユーザページへリダイレクトすること' do
        get edit_admin_category_path(category.id)
        expect(response).to redirect_to user_path(login_user.nickname)
      end
    end

    describe 'PUT /admin/categories/:id' do
      let(:category) { create(:category) }

      before do
        category
      end

      it 'ユーザページへリダイレクトすること' do
        put admin_category_path(category.id), params: { category: { name: category.name } }
        expect(response).to redirect_to user_path(login_user.nickname)
      end
    end

    describe 'DELETE /admin/categories/:id' do
      let(:category) { create(:category) }

      before do
        category
      end

      it 'ユーザページへリダイレクトすること' do
        delete admin_category_path(category.id)
        expect(response).to redirect_to user_path(login_user.nickname)
      end
    end
  end
end
