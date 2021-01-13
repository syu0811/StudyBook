require 'rails_helper'

RSpec.describe "Api::V1::Categories", type: :request do
  let(:user) { create(:user) }
  let(:agent) { create(:agent, user: user) }

  describe "GET /api/v1/categories" do
    let(:categories) { create_list(:category, 2) }

    before do
      categories
    end

    it "カテゴリーの一覧が返ってくる" do
      get api_v1_categories_path(agent_guid: agent.guid, token: agent.token)
      expect(response_json).to include(categories: [{ id: categories[0].id, name: categories[0].name }, { id: categories[1].id, name: categories[1].name }], default_category: { id: nil, name: nil })
    end

    context 'デフォルトカテゴリーが存在する場合' do
      let(:category) { create(:category, name: Category::DEFAULT_CATEGORY_NAME) }

      before do
        category
      end

      it "デフォルトカテゴリーを含む一覧が返ってくる" do
        get api_v1_categories_path(agent_guid: agent.guid, token: agent.token)
        expect(response_json).to include(categories: [{ id: categories[0].id, name: categories[0].name }, { id: categories[1].id, name: categories[1].name }, { id: category.id, name: category.name }], default_category: { id: category.id, name: category.name })
      end
    end
  end
end
