require 'rails_helper'

RSpec.describe "Api::V1::Notes", type: :request, use_influx: true do
  let(:user) { create(:user) }
  let(:agent) { create(:agent, user: user) }

  describe "POST api/v1/notes/uploads" do
    subject { StudyLog.new(user.id).user_monthly_study_length }

    let(:category) { create(:category) }
    let(:time) { "2020-04-01Z00:00:00+0000" }

    before do
      travel_to time
    end

    describe "正常時" do
      context "新規登録時" do
        let(:now_time) { "2020-04-01Z01:00:00+0000" }

        before do
          post api_v1_upload_notes_path, params: { agent_guid: agent.guid, token: agent.token, notes: [{ local_id: 1, title: "テストタイトル", body: "#見出し", category_id: category.id, directory_path: "test/app" }] }
          travel_to now_time
        end

        it "ログが正常に保存されていること" do
          expect(subject).to eq([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4])
        end
      end

      context "更新時" do
        let(:travel_time) { 1.hours }

        before do
          post api_v1_upload_notes_path, params: { agent_guid: agent.guid, token: agent.token, notes: [{ local_id: 1, title: "テストタイトル", body: "更新前1234", category_id: category.id, directory_path: "test/app" }] }
          travel travel_time
          post api_v1_upload_notes_path, params: { agent_guid: agent.guid, token: agent.token, notes: [{ local_id: 1, title: "テストタイトル", body: "更新後", category_id: category.id, directory_path: "test/app", guid: Note.first.guid }] }
          travel travel_time
        end

        it "ログが正常に保存されていること" do
          expect(subject).to eq([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 11])
        end
      end

      context "複数の区分のデータが存在する場合" do
        let(:travel_time) { 1.month }

        before do
          13.times do
            travel travel_time
            post api_v1_upload_notes_path, params: { agent_guid: agent.guid, token: agent.token, notes: [{ local_id: 1, title: "テストタイトル", body: "#見出し", category_id: category.id, directory_path: "test/app" }] }
          end
          travel 1.hours
        end

        it "ログが正常に保存されていること" do
          expect(subject).to eq([4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4])
        end
      end
    end
  end
end
