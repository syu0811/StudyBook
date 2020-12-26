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

    context "ノートが存在する場合" do
      let(:note) { create(:note, user: login_user) }

      before do
        note
      end

      it "ノート数が返ること" do
        get user_path(login_user.nickname)
        expect(response.body).to include("<div class=\'label\'>\n総ノート数\n</div>\n<div class=\'value\'>\n1\n</div>")
      end
    end

    context "マイリストが存在する場合" do
      let(:my_list) { create(:my_list, user: login_user) }

      before do
        my_list
      end

      it "マイリスト数が返ること" do
        get user_path(login_user.nickname)
        expect(response.body).to include("<div class=\'label\'>\n総マイリスト数\n</div>\n<div class=\'value\'>\n1\n</div>")
      end
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

      it "総編集文字数が存在すること" do
        get user_path(login_user.nickname)
        expect(response.body).to include("<div class=\'label\'>\n総編集文字数\n</div>\n<div class=\'value\'>\n100文字\n</div>")
      end
    end

    context "ログが存在しない時" do
      it "全て0埋めされたログが存在すること" do
        get user_path(login_user.nickname)
        expect(response.body).to include('data-graph=\'0,0,0,0,0,0,0,0,0,0,0,0,0\'')
      end

      it "総編集文字数が0なこと" do
        get user_path(login_user.nickname)
        expect(response.body).to include("<div class=\'label\'>\n総編集文字数\n</div>\n<div class=\'value\'>\n0文字\n</div>")
      end
    end
  end
end
