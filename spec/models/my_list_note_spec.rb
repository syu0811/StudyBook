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
end
