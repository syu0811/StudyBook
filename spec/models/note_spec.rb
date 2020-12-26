require 'rails_helper'

RSpec.describe Note, type: :model do
  # describe 大まかな説明
  # context どういった場合になど状況
  # it 何が期待されるか
  describe 'Validation' do
    let(:user) { create(:user) }
    let(:category) { create(:category) }

    context '正常系' do
      it "成功すること" do
        note = build(:note, user: user, category: category)
        expect(note).to be_valid
      end
    end

    context '異常系' do
      it "user_idがない時にエラーが返ること" do
        note = build(:note, user_id: nil)
        note.valid?
        expect(note.errors[:user_id]).to include("を入力してください")
      end

      it "category_idがない時にエラーが返ること" do
        note = build(:note, category_id: nil)
        note.valid?
        expect(note.errors[:category_id]).to include("を入力してください")
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
        note = build(:note, body: "a" * 30001)
        note.valid?
        expect(note.errors[:body]).to include("は30000文字以内で入力してください")
      end

      it "textがない時にエラーが帰ること" do
        note = build(:note, body: nil, user: user)
        note.valid?
        expect(note.errors[:body]).to include("を入力してください")
      end

      it "directory_pathの文字数が255文字を超えている時にエラーが帰ること" do
        note = build(:note, directory_path: "a" * 256)
        note.valid?
        expect(note.errors[:directory_path]).to include("は255文字以内で入力してください")
      end
    end
  end

  describe ".full_search" do
    let(:note_a) { create(:note, title: "これはマイリストAです", body: "これはマイリストAの説明です") }
    let(:note_b) { create(:note, title: "これはマイリストBです", body: "これはマイリストBの説明です") }

    before do
      note_a
      note_b
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
        expect(described_class.full_search(q)).to eq([note_a])
      end
    end

    context "これは 説明 Aで検索" do
      let(:q) { "これは 説明 A" }

      it "Aのマイリストが返る" do
        expect(described_class.full_search(q)).to eq([note_a])
      end
    end

    context "Bです 説明ですで検索" do
      let(:q) { "Bです 説明です" }

      it "結果が0件であること" do
        expect(described_class.full_search(q).size).to eq(0)
      end
    end
  end

  describe '.category_ratio' do
    let(:category) { create(:category) }
    let(:note) { create(:note, category: category) }

    before do
      note
    end

    it "カテゴリー毎の数が返る" do
      expect(described_class.category_ratio).to eq({ category.name.to_s => 1 })
    end
  end

  describe '.tags_search' do
    let(:tags) { create_list(:tag, 2) }
    let(:note) { create(:note) }

    before do
      create(:note_tag, note: note, tag: tags[0])
      create(:note_tag, note: note, tag: tags[1])
    end

    context '存在するタグ1つを指定する場合' do
      it "結果が1件であること" do
        expect(described_class.tags_search(tags[0].name).size).to eq(1)
      end
    end

    context '存在するタグ2つを指定する場合' do
      it "結果が1件であること" do
        expect(described_class.tags_search("#{tags[0].name},#{tags[1].name}").size).to eq(1)
      end
    end

    context '存在しないタグ1つを指定する場合' do
      it "結果が0件であること" do
        expect(described_class.tags_search("NotName").size).to eq(0)
      end
    end
  end

  describe ".get_reladed_notes_list" do
    let(:category_a) { create(:category) }
    let(:category_b) { create(:category) }

    let(:note) { create(:note, category: category_a) }
    let(:note_a) { create(:note, category: category_a) }
    let(:note_b) { create(:note, category: category_b) }

    before do
      category_a
      category_b
      note
      note_a
      note_b
    end

    context "タグがない場合" do
      it "同じカテゴリーのノートを取得できているか" do
        expect(described_class.get_reladed_notes_list(note)).to include(note_a)
      end

      it "関連ノートに現在見ているノートがないか" do
        expect(described_class.get_reladed_notes_list(note)).not_to include(note)
      end

      it "違うカテゴリーのノートが含まれていないか" do
        expect(described_class.get_reladed_notes_list(note)).not_to include(note_b)
      end
    end

    context "タグがある場合" do
      let(:tag_a) { create(:tag) }
      let(:tag_b) { create(:tag) }

      let(:note_ba) { create(:note, category: category_b) }

      let(:note_tag) { create(:note_tag, note: note, tag: tag_a) }
      let(:note_tag_a) { create(:note_tag, note: note_a, tag: tag_a) }
      let(:note_tag_b) { create(:note_tag, note: note_b, tag: tag_b) }
      let(:note_tag_ba) { create(:note_tag, note: note_ba, tag: tag_a) }

      before do
        tag_a
        tag_b

        note_ba

        note_tag
        note_tag_a
        note_tag_b
        note_tag_ba
      end

      it "同じカテゴリーでタグが一致しているノートを取得できているか" do
        expect(described_class.get_reladed_notes_list(note)).to include(note_a)
      end

      it "関連ノートに現在見ているノートがないか" do
        expect(described_class.get_reladed_notes_list(note)).not_to include(note)
      end

      it "違うカテゴリーのノートが含まれていないか" do
        expect(described_class.get_reladed_notes_list(note)).not_to include(note_b)
      end

      it "違うカテゴリーでタグが一致しているノートが含まれていないか" do
        expect(described_class.get_reladed_notes_list(note)).not_to include(note_ba)
      end
    end
  end
end
