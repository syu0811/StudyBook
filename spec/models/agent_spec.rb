require 'rails_helper'

RSpec.describe Agent, type: :model do
  describe 'Validation' do
    let(:user) { create(:user) }

    context '正常系' do
      it "成功" do
        agent = build(:agent, user: user)
        expect(agent).to be_valid
      end
    end

    context '異常系' do
      it "user_idが存在しない場合" do
        agent = build(:agent, user_id: nil)
        agent.valid?
        expect(agent.errors[:user_id]).to include("を入力してください")
      end

      it "tokenが存在しない場合" do
        agent = build(:agent, token: nil)
        agent.valid?
        expect(agent.errors[:token]).to include("を入力してください")
      end
    end
  end
end
