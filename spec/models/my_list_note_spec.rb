require 'rails_helper'

RSpec.describe MyListNote, type: :model do
  describe 'Validation' do
    let(:my_list) { create(:my_list) }
    let(:note) { create(:note) }

    context '正常系' do
      it "成功" do
        my_list_note = build(:my_list_note, my_list: my_list, note: note)
        expect(my_list_note).to be_valid
      end

      it "indexが空の場合 0が設定される" do
        my_list_note = create(:my_list_note, my_list: my_list, note: note, index: nil)
        expect(my_list_note.index).to eq(0)
      end

      context "既にノートが登録されている場合" do
        let(:notes) { create_list(:note, 2) }

        before do
          create(:my_list_note, my_list: my_list, note: notes[0])
        end

        it "追加時、indexが適切に追加される" do
          my_list_note = create(:my_list_note, my_list: my_list, note: notes[1], index: nil)
          expect(my_list_note.index).to eq(1)
        end
      end
    end

    context '異常系' do
      it "my_list_idが空の場合" do
        my_list_note = build(:my_list_note, my_list_id: nil)
        my_list_note.valid?
        expect(my_list_note.errors[:my_list_id]).to include("を入力してください")
      end

      it "note_idが空の場合" do
        my_list_note = build(:my_list_note, note_id: nil)
        my_list_note.valid?
        expect(my_list_note.errors[:note_id]).to include("を入力してください")
      end

      it "my_list_idとnote_idで一意ではない場合" do
        create(:my_list_note, my_list: my_list, note: note)
        my_list_note = build(:my_list_note, my_list: my_list, note: note)
        my_list_note.valid?
        expect(my_list_note.errors[:my_list_id]).to include("はすでに存在します")
      end
    end
  end

  describe ".exchange" do
    context "正常系" do
      let!(:my_list) { create(:my_list) }
      let!(:my_list_notes) { create_list(:my_list_note, 2, my_list: my_list, index: nil) }

      it "trueが返る" do
        expect(my_list_notes[0].exchange(1)).to eq(true)
      end

      it "indexが更新されている" do
        expect do
          my_list_notes[0].exchange(1)
        end.to change { my_list_notes[0].reload.index }.from(0).to(1).and change { my_list_notes[1].reload.index }.from(1).to(0)
      end
    end

    context "更新先indexが0より小さい場合" do
      let!(:my_list_note) { create(:my_list_note) }

      it "falseが返る" do
        expect(my_list_note.exchange(-1)).to eq(false)
      end
    end

    context "更新先indexが既にある最大のindexより大きい場合" do
      let!(:my_list_note) { create(:my_list_note) }

      it "falseが返る" do
        expect(my_list_note.exchange(1)).to eq(false)
      end
    end
  end
end
