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

  describe "/?select=trend_notes" do
    before do
      get root_path(select: 'trend_notes')
    end

    context "読んだログが存在しない場合" do
      it "リクエストが成功すること" do
        expect(response).to have_http_status(:ok)
      end

      it "存在しないメッセージが含まれること" do
        expect(response.body).to include("ノートは存在しません")
      end
    end

    context "読んだログが存在する場合" do
      let(:note) { create(:note) }

      before do
        get note_path(note)
        get root_path(select: 'trend_notes')
      end

      it "リクエストが成功すること" do
        expect(response).to have_http_status(:ok)
      end

      it "ノートの内容が含まれること" do
        expect(response.body).to include(note.title)
      end
    end
  end
end
