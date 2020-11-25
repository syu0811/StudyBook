require 'rails_helper'

RSpec.describe "Admin::Notes", type: :request do
  let(:login_user) { create(:user, admin: true) }
  let(:category) { create(:category) }

  before do
    sign_in login_user
  end

  describe 'GET /admin/notes' do
    let!(:notes) { create_list(:note, 2) }

    it 'ステータス OK が返ってくる' do
      get admin_notes_path
      expect(response).to have_http_status(:ok)
    end

    it "一覧のデータ生成の成功" do
      get admin_notes_path
      expect(response.body).to include(notes[0].title, notes[1].title)
    end
  end

  describe 'GET /admin/notes/new' do
    it 'ステータス OK が返ってくる' do
      get new_admin_note_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /admin/notes' do
    context '正常系' do
      let(:note) { build(:note) }

      it '一覧ページへリダイレクトすること' do
        post admin_notes_path, params: { note: { title: note.title, body: note.body, directory_path: note.directory_path, category_id: category.id, user_id: login_user.id } }
        expect(response).to redirect_to admin_notes_path
      end
    end

    context '異常系' do
      let(:note) { build(:note, title: nil) }

      it '登録に失敗し遷移しない' do
        post admin_notes_path, params: { note: { title: nil } }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /admin/notes/:id/edit' do
    let(:note) { create(:note) }

    before do
      note
    end

    it 'ステータス OK が返ってくる' do
      get edit_admin_note_path(note.id)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PUT /admin/notes/:id' do
    let(:note) { create(:note) }

    before do
      note
    end

    context '正常系' do
      it '一覧ページへリダイレクトすること' do
        put admin_note_path(note.id), params: { note: { title: note.title, body: note.body, directory_path: note.directory_path, category_id: category.id, user_id: login_user.id } }
        expect(response).to redirect_to admin_notes_path
      end
    end

    context '異常系' do
      it '登録に失敗し遷移しない' do
        put admin_note_path(note.id), params: { note: { title: '' } }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'DELETE /admin/notes/:id' do
    let(:note) { create(:note) }

    before do
      note
    end

    it '一覧ページへリダイレクトすること' do
      delete admin_note_path(note.id)
      expect(response).to redirect_to admin_notes_path
    end
  end
end
