require 'rails_helper'

RSpec.describe "Api::V1::Tags", type: :request do
  let(:user) { create(:user) }
  let(:agent) { create(:agent, user: user) }

  describe "GET /api/v1/tags?updated_at=?" do
    let(:tags) { create_list(:tag, 2) }

    before do
      travel_to("2020-4-01 12:00")
      tags
    end

    it "タグの一覧が返ってくる" do
      get api_v1_tags_path(agent_guid: agent.guid, token: agent.token, updated_at: "2020-4-01 11:00")
      expect(response_json).to eq([{ id: tags[0].id, name: tags[0].name }, { id: tags[1].id, name: tags[1].name }])
    end

    context '時間が範囲外のものも混ざっている場合' do
      let(:tag) { create(:tag) }

      before do
        travel_to("2020-4-01 15:00")
        tag
      end

      it "範囲外のものを除いたタグの一覧が返ってくる" do
        get api_v1_tags_path(agent_guid: agent.guid, token: agent.token, updated_at: "2020-4-01 13:00")
        expect(response_json).to eq([{ id: tag.id, name: tag.name }])
      end
    end
  end
end
