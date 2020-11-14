require 'rails_helper'

RSpec.describe DeletedNote, type: :model do
  describe "Validation" do
    let(:user) { create(:user) }

    context '正常系' do
      it "成功" do
        deleted_note = build(:deleted_note, user: user)
        expect(deleted_note).to be_valid
      end
    end
  end

  describe "ノート削除時" do
    let(:note) { create(:note) }

    before do
      note.destroy
    end

    it "DeleteNoteに追加されている" do
      expect(described_class.all.size).to eq(1)
    end
  end
end
