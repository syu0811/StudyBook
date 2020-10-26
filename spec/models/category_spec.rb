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
end
