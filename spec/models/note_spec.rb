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
    let(:category) { create(:category) }
    let(:note) { create(:note, category: category) }

    context "タグがない場合" do
      let(:category_eq_note) { create(:note, category: category) }
      let(:category_not_eq_note) { create(:note) }

      before do
        category_eq_note
        category_not_eq_note
      end

      it "現在見ているノートを含まないカテゴリ一致のノートが返る" do
        expect(described_class.get_reladed_notes_list(note)).to match([category_eq_note])
      end
    end

    context "タグがある場合" do
      let(:tag) { create(:tag) }
      let(:patten_notes) { { category_and_tag_eq_note: create(:note, :set_tags, category: category, tags: [tag]), category_eq_and_tag_not_eq_note: create(:note, :set_tags, category: category), category_not_eq_and_tag_eq: create(:note, :set_tags, tags: [tag]) } }

      before do
        patten_notes
      end

      context "関連するノート数以上に一致しているノートが存在する場合" do
        before do
          stub_const("Note::RELADED_NOTE_LIMIT", 1)
        end

        it "同じカテゴリーでタグが一致しているノートを取得できているか" do
          expect(described_class.get_reladed_notes_list(note)).to match([patten_notes[:category_and_tag_eq_note]])
        end
      end

      context "関連するノート数より一致しているノートが少ない場合" do
        before do
          stub_const("Note::RELADED_NOTE_LIMIT", 2)
        end

        it "カテゴリが一致するノートも含まれていること" do
          expect(described_class.get_reladed_notes_list(note)).to match_array([patten_notes[:category_and_tag_eq_note], patten_notes[:category_eq_and_tag_not_eq_note]])
        end
      end
    end
  end
end
