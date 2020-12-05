require 'rails_helper'

RSpec.describe "Tops", type: :request do
  let(:login_user) { create(:user) }

  before do
    sign_in login_user
  end

  describe "/" do
    let!(:note) { create(:note) }

    it "リクエストが成功すること" do
      get root_path
      expect(response).to have_http_status(:ok)
    end

    it "ノートを取得できているか" do
      get root_path
      expect(response.body).to include(note.title)
    end
  end
end
