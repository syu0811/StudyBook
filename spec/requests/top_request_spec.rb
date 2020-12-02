require 'rails_helper'

RSpec.describe "Tops", type: :request do
  let(:login_user) { create(:user) }

  before do
    sign_in login_user
  end

  describe "/" do
    it "リクエストが成功すること" do
      get root_path
      expect(response).to have_http_status(:ok)
    end
  end
end
