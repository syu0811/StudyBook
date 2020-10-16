require 'rails_helper'

RSpec.describe Note, type: :model do
  # describe 大まかな説明
  # context どういった場合になど状況
  # it 何が期待されるか
  describe 'Validation' do
    let(:user) { create(:user) }
    context '正常系' do
      it "成功すること" do
        note = build(:note, user: user)
        expect(note).to be_valid
      end
    end

    context '異常系' do
      it "user_idがない時にエラーが返ること" do
        note = build(:note, user_id: nil)
        note.valid?
        expect(note.errors[:user_id]).to include("を入力してください")
      end

      it "titleの文字数が50文字を超えている時にエラーが帰ること" do
        note = build(:note, title: "a" * 51)
        note.valid?
        expect(note.errors[:title]).to include("は50文字以内で入力してください")
      end

      it "titleがない時にエラーが帰ること" do
        note = build(:note, title: nil, user: user)
        note.valid?
        expect(note.errors[:title]).to include("を入力してください")
      end

      it "textの文字数が30000文字を超えている時にエラーが帰ること" do
        note = build(:note, text: "a" * 30001)
        note.valid?
        expect(note.errors[:text]).to include("は30000文字以内で入力してください")
      end

      it "textがない時にエラーが帰ること" do
        note = build(:note, text: nil, user: user)
        note.valid?
        expect(note.errors[:text]).to include("を入力してください")
      end
    end
  end
end
