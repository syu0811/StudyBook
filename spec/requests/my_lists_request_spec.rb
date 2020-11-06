require 'rails_helper'

RSpec.describe "MyLists", type: :request do
  describe 'ユーザでログインしている場合' do
    let(:login_user) { create(:user) }

    before do
      sign_in login_user
    end

    describe "GET /my_lists" do
      it 'ステータス OK が返ってくる' do
        get my_lists_path
        expect(response).to have_http_status(:ok)
      end
    end

    describe "GET /my_lists/:id" do
      let!(:my_list) { create(:my_list) }

      it 'ステータス OK が返ってくる' do
        get my_list_path(my_list.id)
        expect(response).to have_http_status(:ok)
      end
    end

    describe "GET /my_lists/new" do
      let!(:note) { create(:note) }

      it 'ステータス OK が返ってくる' do
        get new_my_list_path(note_id: note.id), xhr: true
        expect(response).to have_http_status(:ok)
      end
    end

    describe "POST /my_lists" do
      let!(:category) { create(:category) }
      let!(:note) { create(:note) }
      let!(:my_list) { build(:my_list) }

      it 'マイリスト作成に成功している' do
        post my_lists_path, params: { my_list: { title: my_list.title, description: my_list.description, category_id: category.id, user_id: login_user.id }, note_id: note.id }, xhr: true
        expect(response.body).to include("マイリスト作成に成功しました")
      end
    end

    describe "DELETE /my_lists/:id" do
      let!(:my_list) { create(:my_list, user: login_user) }
      let(:my_list_notes) { create_list(:my_list_note, 2, my_list: my_list) }

      before do
        my_list_notes
      end

      it 'マイリストの削除に成功している' do
        delete my_list_path(my_list.id)
        expect(MyList.all.size).to eq(0)
      end

      it 'マイリストノートの削除に成功している' do
        expect { delete my_list_path(my_list.id) }.to change { MyListNote.all.size }.from(2).to(0)
      end

      it '302が返る' do
        delete my_list_path(my_list.id)
        expect(response).to have_http_status(:found)
      end
    end
  end
end
