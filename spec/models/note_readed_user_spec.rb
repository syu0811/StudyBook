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
      it "user_idが無ければ失敗する" do
        note_readed_user = build(:note_readed_user, note: note, user_id: nil)
        note_readed_user.valid?
        expect(note_readed_user.errors[:user_id]).to include("を入力してください")
      end

      it "note_idが無ければ失敗する" do
        note_readed_user = build(:note_readed_user, note_id: nil, user: user)
        note_readed_user.valid?
        expect(note_readed_user.errors[:note_id]).to include("を入力してください")
      end

      it "note_idとuser_idが重複している場合" do
        create(:note_readed_user, note: note, user: user)
        note_readed_user = build(:note_readed_user, note: note, user: user)
        note_readed_user.valid?
        expect(note_readed_user.errors[:user_id]).to include("はすでに存在します")
      end
    end
  end

  describe ".get_reladed_notes_list" do
    let(:category_a) { create(:category) }
    let(:category_b) { create(:category) }

    let(:note) { create(:note, user: user_a, category: category_a) }
    let(:note_a) { create(:note, user: user_b, category: category_a) }
    let(:note_b) { create(:note, user: user_b, category: category_b) }

    let(:user_a) { create(:user) }
    let(:user_b) { create(:user) }

    before do
      category_a
      category_b

      user_a
      user_b

      note
      note_a
      note_b
    end

    context "タグがない場合" do
      it "同じカテゴリーのノートを取得できているか" do
        expect(described_class.get_reladed_notes_list(note)).to include(note_a)
      end

      it "関連ノートに現在見ているノートがない" do
        expect(described_class.get_reladed_notes_list(note)).not_to eq(note)
      end

      it "違うカテゴリーのノートが含まれていないか" do
        expect(described_class.get_reladed_notes_list(note)).not_to include(note_b)
      end
    end

    context "タグがある場合" do
      let(:tag_a) { create(:tag) }
      let(:tag_b) { create(:tag) }

      let(:note_ab) { create(:note, user: user_b, category: category_a) }
      let(:note_aa) { create(:note, user: user_b, category: category_a) }
      let(:note_ba) { create(:note, user: user_b, category: category_b) }

      let(:note_tag_a) { create(:note_tag, note: note_a, tag: tag_a) }
      let(:note_tag_aa) { create(:note_tag, note: note_aa, tag: tag_a) }
      let(:note_tag_ab) { create(:note_tag, note: note_ab, tag: tag_b) }
      let(:note_tag_ba) { create(:note_tag, note: note_ba, tag: tag_a) }
      let(:note_tag_b) { create(:note_tag, note: note_b, tag: tag_b) }

      before do
        tag_a
        tag_b

        note_ab
        note_aa
        note_ba

        note_tag_a
        note_tag_aa
        note_tag_ab
        note_tag_ba
        note_tag_b
      end

      it "同じカテゴリーのノートを取得できているか" do
        expect(described_class.get_reladed_notes_list(note_a)).to include(note_aa)
      end

      it "関連ノートに現在見ているノートがない" do
        expect(described_class.get_reladed_notes_list(note_a)).not_to include(note_a)
      end

      it "違うカテゴリーのノートが含まれていないか" do
        expect(described_class.get_reladed_notes_list(note_a)).not_to include(note_b)
      end

      it "同じカテゴリーでタグが一致していないノートが含まれているか" do
        expect(described_class.get_reladed_notes_list(note_a)).to include(note_ab)
      end

      it "違うカテゴリーでタグが一致しているノートが含まれていないか" do
        expect(described_class.get_reladed_notes_list(note_a)).not_to include(note_ba)
      end

      it "タグが一致しているノートが上位に来るようにソートできているか" do
        expect(described_class.get_reladed_notes_list(note_a)).to match [note_aa, note_ab]
      end
    end
  end
end
