require 'rails_helper'

RSpec.describe "Users", type: :request, use_influx: true do
  let(:login_user) { create(:user) }

  describe 'GET /users/:id' do
    let(:time) { "2020-04-01Z00:00:00+0000" }

    before do
      sign_in login_user
      travel_to time
    end

    it 'user page is displayed' do
      get user_path(login_user.nickname)
      expect(response).to have_http_status(:ok)
    end

    context "ログが存在する時" do
      let(:logs) { [{ note_id: 1, word_count: 100 }] }

      before do
        StudyLog.new(login_user.id).write_study_log(logs)
      end

      it "当月のログが存在すること" do
        get user_path(login_user.nickname)
        expect(response.body).to include('data-graph=\'0,0,0,0,0,0,0,0,0,0,0,0,100\'')
      end
    end

    context "ログが存在しない時" do
      it "全て0埋めされたログが存在すること" do
        get user_path(login_user.nickname)
        expect(response.body).to include('data-graph=\'0,0,0,0,0,0,0,0,0,0,0,0,0\'')
      end
    end
  end
end
