require 'rails_helper'

RSpec.describe "Notes", type: :request do
  describe 'ユーザでログインしている場合' do
    let(:login_user) { create(:user) }

    before do
      sign_in login_user
    end

    describe "GET /notes" do
      it 'ステータス OK が返ってくる' do
        get notes_path
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'GET /notes/:id' do
      let(:note) { create(:note) }

      it 'note page is displayed' do
        get note_path(note.id)
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'GET /notes/:id?index=?&my_list_id=?' do
      let!(:my_list) { create(:my_list) }
      let!(:note) { create(:note) }
      let(:my_list_note) { create(:my_list_note, my_list: my_list, note: note) }

      it 'マイリストを取得できているか' do
        get note_path(id: my_list_note.note.id, index: my_list_note.index, my_list_id: my_list_note.my_list_id)
        expect(response.body).to include(my_list_note.note.title)
      end
    end
  end
end
