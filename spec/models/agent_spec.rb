require 'rails_helper'

RSpec.describe Agent, type: :model do
  describe 'Validation' do
    context '正常系' do
      it "成功" do
        agent = build(:agent)
        expect(agent).to be_valid
      end
    end
=begin
    context '異常系' do
      it "user_idが存在しない場合" do
        agent = build(:agent, user_id: nil)
        agent.valid?
        expect(agent.errors[:user_id]).to include("が存在しません")
      end

      it "guidがない場合" do
        agent = build(:agent, guid: nil)
        agent.valid?
        expect(agent.errors[:guid]).to include("が存在しません")
      end

      it "guidがすでに格納されている場合" do
        guid = "e0fc86fc-fb45-4351-8b2e-e8c2f3cbfgsd"
        create(:agent, guid: guid)
        agent = build(:agent, guid: guid)
        agent.valid?
        expect(agent.errors[:guid]).to include("はすでに存在します")
      end
    end
=end
  end
end
