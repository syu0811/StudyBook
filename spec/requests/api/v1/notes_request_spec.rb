require 'rails_helper'

RSpec.describe "Api::V1::Notes", type: :request do
  let!(:user) { create(:user) }
  let(:agent) { create(:agent, user: user) }

  describe "POST api/v1/notes/uploads" do
    let!(:category) { create(:category) }

    describe "正常時" do
      context "新規登録時" do
        it "ノートのguidとlocal_idが返ること" do
          post api_v1_upload_notes_path, params: { agent_guid: agent.guid, token: agent.token, notes: [{ local_id: 1, title: "テストタイトル", body: "#見出し", category_id: category.id, directory_path: "test/app" }] }
          expect(response_json).to eq([{ local_id: "1", guid: Note.first.guid, errors: {}, tag_errors: [] }])
        end

        context "タグも同時に登録するとき" do
          before do
            post api_v1_upload_notes_path, params: { agent_guid: agent.guid, token: agent.token, notes: [{ local_id: 1, title: "テストタイトル", body: "#見出し", category_id: category.id, directory_path: "test/app", tags: [{ name: "タグテスト1" }, { name: "タグテスト2" }] }] }
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
              post api_v1_upload_notes_path, params: { agent_guid: agent.guid, token: agent.token, notes: [{ local_id: 1, title: "テストタイトル", body: "#見出し", category_id: category.id, directory_path: "test/app", tags: [{ id: tag.id, name: nil }, { id: nil, name: "タグテスト" }] }] }
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
              post api_v1_upload_notes_path, params: { agent_guid: agent.guid, token: agent.token, notes: [{ local_id: 1, title: "テストタイトル", body: "#見出し", category_id: category.id, directory_path: "test/app", tags: [{ id: tag.id, name: "" }, { id: "", name: "タグテスト" }] }] }
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
          post api_v1_upload_notes_path, params: { agent_guid: agent.guid, token: agent.token, notes: [{ local_id: 1, guid: note.guid, title: "テストタイトル", body: "#見出し", category_id: category.id, directory_path: "test/app" }] }
          expect(response_json).to eq([{ local_id: "1", guid: note.guid, errors: {}, tag_errors: [] }])
        end

        context "タグも同時に更新するとき" do
          let!(:note_tag) { create(:note_tag, note: note) }

          before do
            post api_v1_upload_notes_path, params: { agent_guid: agent.guid, token: agent.token, notes: [{ local_id: 1, guid: note.guid, title: "テストタイトル", body: "#見出し", category_id: category.id, directory_path: "test/app", tags: [{ name: "タグテスト1" }, { name: "タグテスト2" }] }] }
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

        context "タグを消すとき" do
          let(:note_tag) { create(:note_tag, note: note) }

          before do
            note_tag
            post api_v1_upload_notes_path, params: { agent_guid: agent.guid, token: agent.token, notes: [{ local_id: 1, guid: note.guid, title: "テストタイトル", body: "#見出し", category_id: category.id, directory_path: "test/app", tags: [] }] }
          end

          it "タグが0件になっている" do
            expect(NoteTag.where(note: note).size).to eq(0)
          end
        end
      end
    end

    describe "異常系" do
      context "新規登録時" do
        context "存在しないguidが指定されたとき" do
          before do
            post api_v1_upload_notes_path, params: { agent_guid: agent.guid, token: agent.token, notes: [{ local_id: 1, guid: "notguid", title: "テストタイトル", body: "#見出し", category_id: category.id, directory_path: "test/app" }] }
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
            post api_v1_upload_notes_path, params: { agent_guid: agent.guid, token: agent.token, notes: [{ local_id: 1, guid: "notguid", title: "テストタイトル", body: "#見出し", category_id: nil, directory_path: "test/app" }] }
            expect(response_json).to eq([{ local_id: "1", guid: nil, errors: { category: [{ error: "blank" }], category_id: [{ error: "blank" }] }, tag_errors: [] }])
          end
        end

        context "間違ったタグidを指定するとき" do
          before do
            post api_v1_upload_notes_path, params: { agent_guid: agent.guid, token: agent.token, notes: [{ local_id: 1, title: "テストタイトル", body: "#見出し", category_id: category.id, directory_path: "test/app", tags: [{ id: 1000000, name: "" }, { id: "", name: "タグテスト2" }] }] }
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
            post api_v1_upload_notes_path, params: { agent_guid: agent.guid, token: agent.token, notes: [{ local_id: 1, title: "テストタイトル", body: "#見出し", category_id: category.id, directory_path: "test/app", tags: [{ id: "", name: "a" * 256 }, { id: "", name: "タグテスト2" }] }] }
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

  describe 'GET api/v1/notes/downloads' do
    before do
      travel_to("2020-4-01 12:00")
    end

    describe "正常時" do
      let!(:note) { create(:note, user: user) }
      let!(:note_tag) { create(:note_tag, note: note) }
      let!(:deleted_note) { create(:deleted_note, user: user, guid: 'aaaaaaaa-0000-aaaa-0000-aaaaaaaaaaaa') }

      before do
        get api_v1_download_notes_path(agent_guid: agent.guid, token: agent.token, updated_at: updated_at)
      end

      context "更新対象を含む時間を指定する場合" do
        let(:updated_at) { "2020-4-01 11:00" }

        it "ノート一覧が返る" do
          expect(response_json).to eq({ notes: [{ guid: note.guid, title: note.title, body: note.body, directory_path: note.directory_path, category_id: note.category_id, tags: [{ id: note_tag.tag.id, name: note_tag.tag.name }], updated_at: note.updated_at.iso8601 }], deleted_notes: [{ guid: deleted_note.guid }] })
        end
      end

      context "更新対象を含まない時間を指定する場合" do
        let(:updated_at) { "2020-4-01 13:00" }

        it "空のノート一覧が返る" do
          expect(response_json).to eq({ notes: [], deleted_notes: [{ guid: deleted_note.guid }] })
        end
      end
    end
  end

  describe 'DELETE api/v1/notes' do
    describe "正常時" do
      let!(:notes) { create_list(:note, 5, user: user) }

      it "ノートが削除されていること" do
        delete api_v1_delete_notes_path, params: { agent_guid: agent.guid, token: agent.token, notes: notes.map { |note| { guid: note.guid } } }
        expect(Note.all.size).to eq(0)
      end

      it "削除されたノート情報が返ること" do
        delete api_v1_delete_notes_path, params: { agent_guid: agent.guid, token: agent.token, notes: notes.map { |note| { guid: note.guid } } }
        expect(response_json.size).to eq(5)
      end
    end

    describe "異常時" do
      context "ユーザのノートでは無いノートを削除するとき" do
        let!(:notes) { create_list(:note, 5) }

        before do
          delete api_v1_delete_notes_path, params: { agent_guid: agent.guid, token: agent.token, notes: notes.map { |note| { guid: note.guid } } }
        end

        it "ノートが削除されていないこと" do
          expect(Note.all.size).to eq(5)
        end

        it "レスポンスが空なこと" do
          expect(response_json).to eq([])
        end
      end
    end
  end
end
