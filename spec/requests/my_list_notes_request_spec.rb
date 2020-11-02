require 'rails_helper'

RSpec.describe "MyListNotes", type: :request do
  describe 'ユーザでログインしている場合' do
    let(:login_user) { create(:user) }

    before do
      sign_in login_user
    end

    describe "GET /my_lists/new" do
      let!(:note) { create(:note) }

      it 'ステータス OK が返ってくる' do
        get new_my_list_path(note_id: note.id), xhr: true
        expect(response).to have_http_status(:ok)
      end
    end

    describe "POST /my_list_notes" do
      context 'ログインユーザのマイリストに追加する場合' do
        let!(:note) { create(:note) }
        let!(:my_list) { create(:my_list, user: login_user) }

        it 'マイリスト追加に成功している' do
          post create_my_list_note_path, params: { my_list_id: my_list.id, note_id: note.id }, xhr: true
          expect(response.body).to include("#{my_list.title}に追加しました")
        end
      end

      context 'ログインユーザではないマイリストに追加する場合' do
        let!(:note) { create(:note) }
        let!(:my_list) { create(:my_list) }

        it 'RecordNotFoundが発生' do
          expect do
            post create_my_list_note_path, params: { my_list_id: my_list.id, note_id: note.id }, xhr: true
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    describe "DELETE /my_list_notes" do
      context 'ログインユーザのマイリストのものを削除する場合' do
        let!(:my_list) { create(:my_list, user: login_user) }
        let!(:my_list_note) { create(:my_list_note, my_list: my_list) }

        it 'no_contentが返る' do
          delete destroy_my_list_note_path, params: { my_list_id: my_list_note.my_list_id, note_id: my_list_note.note_id }, xhr: true
          expect(response).to have_http_status(:no_content)
        end

        context 'ログインユーザではないマイリストのものを削除する場合' do
          let!(:my_list_note) { create(:my_list_note) }

          it 'RecordNotFoundが発生' do
            expect do
              delete destroy_my_list_note_path, params: { my_list_id: my_list_note.my_list_id, note_id: my_list_note.note_id }, xhr: true
            end.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end
    end
  end
end
