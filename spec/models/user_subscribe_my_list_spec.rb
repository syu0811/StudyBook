require 'rails_helper'

RSpec.describe UserSubscribeMyList, type: :model do
  describe 'Validation' do
    let(:my_list) { create(:my_list) }
    let(:user) { create(:user) }

    context '正常系' do
      it "成功" do
        user_subscribe_my_list = build(:user_subscribe_my_list, my_list: my_list, user: user)
        expect(user_subscribe_my_list).to be_valid
      end
    end

    context '異常系' do
      it "my_list_idが空の場合" do
        user_subscribe_my_list = build(:user_subscribe_my_list, my_list_id: nil)
        user_subscribe_my_list.valid?
        expect(user_subscribe_my_list.errors[:my_list_id]).to include("を入力してください")
      end

      it "user_idが空の場合" do
        user_subscribe_my_list = build(:user_subscribe_my_list, user_id: nil)
        user_subscribe_my_list.valid?
        expect(user_subscribe_my_list.errors[:user_id]).to include("を入力してください")
      end

      it "my_list_idとuser_idで一意ではない場合" do
        create(:user_subscribe_my_list, my_list: my_list, user: user)
        user_subscribe_my_list = build(:user_subscribe_my_list, my_list: my_list, user: user)
        user_subscribe_my_list.valid?
        expect(user_subscribe_my_list.errors[:user_id]).to include("はすでに存在します")
      end
    end
  end
end
