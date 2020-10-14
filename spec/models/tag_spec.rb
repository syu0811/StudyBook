require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'Validation' do
    context '正常系' do
      it "成功する" do
        tag = build(:tag)
        expect(tag).to be_valid
      end
    end

    context '異常系' do
      it "nameが無ければ失敗する" do
        tag = build(:tag, name: nil)
        tag.valid?
        expect(tag.errors[:name]).to include("を入力してください")
      end

      it "nameが重複していると失敗する" do
        name = "test_name"
        create(:tag, name: name)
        tag = build(:tag, name: name)
        tag.valid?
        expect(tag.errors[:name]).to include("はすでに存在します")
      end
    end
  end
end
