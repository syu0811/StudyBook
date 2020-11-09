require 'rails_helper'

RSpec.describe NoteTag, type: :model do
  describe 'Validation' do
    let!(:note) { create(:note) }
    let!(:tag) { create(:tag) }

    context '正常系' do
      it "成功する" do
        note_tag = build(:note_tag, note: note, tag: tag)
        expect(note_tag).to be_valid
      end
    end

    context '異常系' do
      it "note_idが無ければ失敗する" do
        note_tag = build(:note_tag, note_id: nil)
        note_tag.valid?
        expect(note_tag.errors[:note_id]).to include("を入力してください")
      end

      it "tag_idが無ければ失敗する" do
        note_tag = build(:note_tag, tag_id: nil)
        note_tag.valid?
        expect(note_tag.errors[:tag_id]).to include("を入力してください")
      end

      it "note_idとtag_idが重複している場合" do
        create(:note_tag, note: note, tag: tag)
        note_tag = build(:note_tag, note: note, tag: tag)
        note_tag.valid?
        expect(note_tag.errors[:tag_id]).to include("はすでに存在します")
      end
    end
  end
end
