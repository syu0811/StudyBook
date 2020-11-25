require 'rails_helper'

RSpec.describe "Api::V1::Categories", type: :request do
  let(:user) { create(:user) }

  describe "GET /api/v1/categories?updated_at=?" do
    let(:categories) { create_list(:category, 2) }

    before do
      travel_to("2020-4-01 12:00")
      categories
    end

    it "タグの一覧が返ってくる" do
      get api_v1_categories_path(id: user.id, token: user.token, updated_at: "2020-4-01 11:00")
      expect(response_json).to eq([{ id: categories[0].id, name: categories[0].name }, { id: categories[1].id, name: categories[1].name }])
    end

    context '時間が範囲外のものも混ざっている場合' do
      let(:category) { create(:category) }

      before do
        travel_to("2020-4-01 15:00")
        category
      end

      it "範囲外のものを除いたタグの一覧が返ってくる" do
        get api_v1_categories_path(id: user.id, token: user.token, updated_at: "2020-4-01 13:00")
        expect(response_json).to eq([{ id: category.id, name: category.name }])
      end
    end
  end
end
