require 'rails_helper'

RSpec.describe MyList, type: :model do
  describe 'Validation' do
    let(:user) { create(:user) }
    let(:category) { create(:category) }

    describe '正常系' do
      it "成功すること" do
        my_list = build(:my_list, user: user, category: category)
        expect(my_list).to be_valid
      end
    end

    describe '異常系' do
      it "user_idがない時にエラーが返ること" do
        my_list = build(:my_list, user_id: nil, category: category)
        my_list.valid?
        expect(my_list.errors[:user_id]).to include("を入力してください")
      end

      it "category_idがない時にエラーが返ること" do
        my_list = build(:my_list, category_id: nil, user: user, category: category)
        my_list.valid?
        expect(my_list.errors[:category_id]).to include("を入力してください")
      end

      it "titleの文字数が50文字を超えている時にエラーが帰ること" do
        my_list = build(:my_list, title: "a" * 51, category: category)
        my_list.valid?
        expect(my_list.errors[:title]).to include("は50文字以内で入力してください")
      end

      it "titleがない時にエラーが帰ること" do
        my_list = build(:my_list, title: nil, user: user, category: category)
        my_list.valid?
        expect(my_list.errors[:title]).to include("を入力してください")
      end

      it "descriptionの文字数が300文字を超えている時にエラーが帰ること" do
        my_list = build(:my_list, description: "a" * 301, category: category)
        my_list.valid?
        expect(my_list.errors[:description]).to include("は300文字以内で入力してください")
      end

      it "descriptionがない時にエラーが帰ること" do
        my_list = build(:my_list, description: nil, user: user, category: category)
        my_list.valid?
        expect(my_list.errors[:description]).to include("を入力してください")
      end
    end
  end

  describe ".full_search" do
    let(:user) { create(:user) }
    let(:category) { create(:category) }
    let(:my_list_a) { create(:my_list, user: user, category: category, title: "これはマイリストAです", description: "これはマイリストAの説明です") }
    let(:my_list_b) { create(:my_list, user: user, category: category, title: "これはマイリストBです", description: "これはマイリストBの説明です") }

    before do
      user
      my_list_a
      my_list_b
    end

    context "これはで検索" do
      let(:q) { "これは" }

      it "全てのマイリストが返る" do
        expect(described_class.full_search(q).size).to eq(2)
      end
    end

    context "Aで検索" do
      let(:q) { "A" }

      it "Aのマイリストが返る" do
        expect(described_class.full_search(q)).to eq([my_list_a])
      end
    end

    context "これは 説明 Aで検索" do
      let(:q) { "これは 説明 A" }

      it "Aのマイリストが返る" do
        expect(described_class.full_search(q)).to eq([my_list_a])
      end
    end

    context "Bです 説明ですで検索" do
      let(:q) { "Bです 説明です" }

      it "結果が0件であること" do
        expect(described_class.full_search(q).size).to eq(0)
      end
    end
  end
end
