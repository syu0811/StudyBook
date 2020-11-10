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
  end
end
