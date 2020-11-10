require 'rails_helper'

RSpec.describe "Users::Notes", type: :request do
  describe 'ユーザでログインしている場合' do
    let(:login_user) { create(:user) }

    before do
      sign_in login_user
    end

    describe "GET users/:user_nickname/notes" do
      it 'ステータス OK が返ってくる' do
        get user_notes_path(user_nickname: login_user.nickname)
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
