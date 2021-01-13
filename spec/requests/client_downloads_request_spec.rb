require 'rails_helper'

RSpec.describe "ClientDownloads", type: :request do
  let(:login_user) { create(:user, admin: true) }

  before do
    sign_in login_user
  end

  describe 'GET /client_downloads' do
    it 'ステータス OK が返ってくる' do
      get client_downloads_path
      expect(response).to have_http_status(:ok)
    end
  end
end
