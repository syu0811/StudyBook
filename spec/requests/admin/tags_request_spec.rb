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

    describe 'GET /admin/tags/:id/edit' do
      let(:tag) { create(:tag) }

      before do
        tag
      end

      it 'ステータス OK が返ってくる' do
        get edit_admin_tag_path(tag.id)
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'PUT /admin/tags/:id' do
      let(:tag) { create(:tag) }

      before do
        tag
      end

      context '正常系' do
        it '一覧ページへリダイレクトすること' do
          put admin_tag_path(tag.id), params: { tag: { name: tag.name } }
          expect(response).to redirect_to admin_tags_path
        end
      end

      context '異常系' do
        it '登録に失敗し遷移しない' do
          put admin_tag_path(tag.id), params: { tag: { name: '' } }
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end
end
