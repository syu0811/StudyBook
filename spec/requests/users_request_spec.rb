require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:login_user) { create(:user) }

  describe 'GET /users/:id' do
    before do
      sign_in login_user
    end

    it 'user page is displayed' do
      get user_path(login_user.nickname)
      expect(response).to have_http_status(:ok)
    end
  end
end
