require 'rails_helper'

RSpec.describe "Api::V1::Notes", type: :request do
  describe "POST api/v1/notes/uploads" do
    let!(:category) { create(:category) }
    let!(:user) { create(:user) }

    describe "正常時" do
      context "新規登録時" do
        it "ノートのguidとlocal_idが返ること" do
          post api_v1_upload_notes_path, params: { id: user.id, token: user.token, notes: [{ local_id: 1, title: "テストタイトル", text: "#見出し", category_id: category.id, file_path: "test/app" }] }
          expect(response_json).to eq([{ local_id: "1", guid: Note.first.guid, errors: {}, tag_errors: [] }])
        end

        context "タグも同時に登録するとき" do
          before do
            post api_v1_upload_notes_path, params: { id: user.id, token: user.token, notes: [{ local_id: 1, title: "テストタイトル", text: "#見出し", category_id: category.id, file_path: "test/app", tags: [{ name: "タグテスト1" }, { name: "タグテスト2" }] }] }
          end

          it "ノートのguidとlocal_idが返ること" do
            expect(response_json).to eq([{ local_id: "1", guid: Note.first.guid, errors: {}, tag_errors: [] }])
          end

          it "ノートタグが登録されていること" do
            expect(NoteTag.all.size).to eq(2)
          end
        end

        context "存在するタグで登録するとき" do
          let!(:tag) { create(:tag) }

          context "存在しない方はnilで指定" do
            before do
              post api_v1_upload_notes_path, params: { id: user.id, token: user.token, notes: [{ local_id: 1, title: "テストタイトル", text: "#見出し", category_id: category.id, file_path: "test/app", tags: [{ id: tag.id, name: nil }, { id: nil, name: "タグテスト" }] }] }
            end

            it "ノートのguidとlocal_idが返ること" do
              expect(response_json).to eq([{ local_id: "1", guid: Note.first.guid, errors: {}, tag_errors: [] }])
            end

            it "ノートタグが登録されていること" do
              expect(NoteTag.all.size).to eq(2)
            end
          end

          context "存在しない方は空文字で指定" do
            before do
              post api_v1_upload_notes_path, params: { id: user.id, token: user.token, notes: [{ local_id: 1, title: "テストタイトル", text: "#見出し", category_id: category.id, file_path: "test/app", tags: [{ id: tag.id, name: "" }, { id: "", name: "タグテスト" }] }] }
            end

            it "ノートのguidとlocal_idが返ること" do
              expect(response_json).to eq([{ local_id: "1", guid: Note.first.guid, errors: {}, tag_errors: [] }])
            end

            it "ノートタグが登録されていること" do
              expect(NoteTag.all.size).to eq(2)
            end
          end
        end
      end

      context "更新時" do
        let!(:note) { create(:note, user: user, category: category) }

        it "ノートのguidとlocal_idが返ること" do
          post api_v1_upload_notes_path, params: { id: user.id, token: user.token, notes: [{ local_id: 1, guid: note.guid, title: "テストタイトル", text: "#見出し", category_id: category.id, file_path: "test/app" }] }
          expect(response_json).to eq([{ local_id: "1", guid: note.guid, errors: {}, tag_errors: [] }])
        end

        context "タグも同時に更新するとき" do
          let!(:note_tag) { create(:note_tag, note: note) }

          before do
            post api_v1_upload_notes_path, params: { id: user.id, token: user.token, notes: [{ local_id: 1, guid: note.guid, title: "テストタイトル", text: "#見出し", category_id: category.id, file_path: "test/app", tags: [{ name: "タグテスト1" }, { name: "タグテスト2" }] }] }
          end

          it "ノートのguidとlocal_idが返ること" do
            expect(response_json).to eq([{ local_id: "1", guid: Note.first.guid, errors: {}, tag_errors: [] }])
          end

          it "ノートタグが登録されていること" do
            expect(NoteTag.all.size).to eq(2)
          end

          it "既に登録されているタグが消えていること" do
            expect { NoteTag.find(note_tag.id) }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end
    end

    describe "異常系" do
      context "新規登録時" do
        context "存在しないguidが指定されたとき" do
          before do
            post api_v1_upload_notes_path, params: { id: user.id, token: user.token, notes: [{ local_id: 1, guid: "notguid", title: "テストタイトル", text: "#見出し", category_id: category.id, file_path: "test/app" }] }
          end

          it "指定したguidでは無いguidが返ること" do
            expect(response_json).not_to include(guid: "notguid")
          end

          it "新規登録されたguidが返ること" do
            expect(response_json).to eq([{ local_id: "1", guid: Note.first.guid, errors: {}, tag_errors: [] }])
          end
        end

        context "カテゴリーを指定しないとき" do
          it "guidはnullでerrorが返ること" do
            post api_v1_upload_notes_path, params: { id: user.id, token: user.token, notes: [{ local_id: 1, guid: "notguid", title: "テストタイトル", text: "#見出し", category_id: nil, file_path: "test/app" }] }
            expect(response_json).to eq([{ local_id: "1", guid: nil, errors: { category: [{ error: "blank" }], category_id: [{ error: "blank" }] }, tag_errors: [] }])
          end
        end

        context "間違ったタグidを指定するとき" do
          before do
            post api_v1_upload_notes_path, params: { id: user.id, token: user.token, notes: [{ local_id: 1, title: "テストタイトル", text: "#見出し", category_id: category.id, file_path: "test/app", tags: [{ id: 1000000, name: "" }, { id: "", name: "タグテスト2" }] }] }
          end

          it "間違ったタグがエラーとして返る" do
            expect(response_json).to eq([{ local_id: "1", guid: Note.first.guid, errors: {}, tag_errors: [{ id: "1000000", name: "" }] }])
          end

          it "後続のタグが登録されていること" do
            expect(Note.find_by(guid: response_json[0][:guid]).note_tags.size).to eq(1)
          end
        end

        context "間違ったタグ名を指定するとき" do
          before do
            post api_v1_upload_notes_path, params: { id: user.id, token: user.token, notes: [{ local_id: 1, title: "テストタイトル", text: "#見出し", category_id: category.id, file_path: "test/app", tags: [{ id: "", name: "a" * 256 }, { id: "", name: "タグテスト2" }] }] }
          end

          it "間違ったタグがエラーとして返る" do
            expect(response_json).to eq([{ local_id: "1", guid: Note.first.guid, errors: {}, tag_errors: [{ id: "", name: "a" * 256 }] }])
          end

          it "後続のタグが登録されていること" do
            expect(Note.find_by(guid: response_json[0][:guid]).note_tags.size).to eq(1)
          end
        end
      end
    end
  end
end
