require 'rails_helper'

RSpec.describe NoteReadedUser, type: :model do
  describe 'Validation' do
    let(:note) { create(:note) }
    let(:user) { create(:user) }

    context '正常系' do
      it "成功する" do
        note_readed_user = build(:note_readed_user, note: note, user: user)
        expect(note_readed_user).to be_valid
      end
    end

    context '異常系' do
      it "user_idがない時にエラーが返ること" do
        note_readed_user = build(:note_readed_user, note: note, user_id: nil)
        note_readed_user.valid?
        expect(note_readed_user.errors[:user_id]).to include("を入力してください")
      end

      it "note_idがない時にエラーが返ること" do
        note_readed_user = build(:note_readed_user, note_id: nil, user: user)
        note_readed_user.valid?
        expect(note_readed_user.errors[:note_id]).to include("を入力してください")
      end
    end

    describe ".get_reladed_notes_list" do
      it "関連ノートの取得" do
        expect(described_class.get_reladed_notes_list(note)).not_to eq(nil)
      end
    end
  end
end
