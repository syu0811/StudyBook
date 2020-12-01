require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'Validation' do
    context '正常系' do
      it "成功" do
        category = build(:category)
        expect(category).to be_valid
      end
    end

    context '異常系' do
      it "nameが20文字を超える場合" do
        category = build(:category, name: "a" * 21)
        category.valid?
        expect(category.errors[:name]).to include("は20文字以内で入力してください")
      end

      it "nameが空の場合" do
        category = build(:category, name: nil)
        category.valid?
        expect(category.errors[:name]).to include("を入力してください")
      end

      it "nameが重複している場合" do
        name = "test_name"
        create(:category, name: name)
        category = build(:category, name: name)
        category.valid?
        expect(category.errors[:name]).to include("はすでに存在します")
      end
    end
  end

  describe ".default_category" do
    context 'デフォルトカテゴリーが存在する場合' do
      let(:category) { create(:category, name: Category::DEFAULT_CATEGORY_NAME) }

      before do
        category
      end

      it "デフォルトカテゴリーが返ること" do
        expect(described_class.default_category).to eq(category)
      end
    end

    context 'デフォルトカテゴリーが存在しない場合' do
      it "nilが返ること" do
        expect(described_class.default_category).to eq(nil)
      end
    end
  end
end
