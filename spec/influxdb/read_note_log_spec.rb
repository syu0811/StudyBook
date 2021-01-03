require 'rails_helper'

RSpec.describe "ReadNoteLogSpec", use_influx: true do
  let(:user) { create(:user) }

  describe ".write_read_note_log" do
    subject { ReadNoteLog.new(user.id).write_read_note_log(logs) }

    let(:note_id) { 1 }

    context '時間を指定せずにログを書き込んだ時' do
      let(:logs) { [{ note_id: note_id }] }

      it "trueが返ること" do
        expect(subject).to eq(true)
      end
    end

    context '時間を指定してログを書き込んだ時' do
      let(:logs) { [{ note_id: note_id, date_at: Time.now.ago(1.days).utc }] }

      it "trueが返ること" do
        expect(subject).to eq(true)
      end
    end
  end

  describe ".total_read_note_count" do
    subject { ReadNoteLog.new(user.id).total_read_note_count(note_id) }

    let(:note_id) { 1 }

    context "データが存在しない場合" do
      it "0が返る" do
        expect(subject).to eq(0)
      end
    end

    context "データが存在する場合" do
      let(:time) { "2020-04-01Z00:00:00+0000" }
      let(:logs) { [{ note_id: note_id }] }

      def create_log(user, logs)
        ReadNoteLog.new(user.id).write_read_note_log(logs)
      end

      before do
        travel_to time
      end

      context "データが1つの場合" do
        before do
          create_log(user, logs)
          travel 1.hours
        end

        it "1が返る" do
          expect(subject).to eq(1)
        end
      end

      context "他ユーザのデータが混在する場合" do
        let(:other_user) { create(:user) }

        before do
          create_log(user, logs)
          create_log(other_user, logs)
          travel 1.hours
        end

        it "2が返る" do
          expect(subject).to eq(2)
        end
      end
    end
  end

  describe '.number_read_per_note' do
    subject { ReadNoteLog.new(user.id).number_read_per_note(limit) }

    let(:limit) { 10 }

    context "データが存在しない場合" do
      it "空の配列が返る" do
        expect(subject).to eq([])
      end
    end

    context "データが存在する場合" do
      let(:time) { "2020-04-01Z00:00:00+0000" }

      def create_log(user, logs)
        ReadNoteLog.new(user.id).write_read_note_log(logs)
      end

      before do
        travel_to time
      end

      context "データが1つの場合" do
        let(:logs) { [{ note_id: 1 }] }

        before do
          create_log(user, logs)
          travel 1.hours
        end

        it "1つの要素が返る" do
          expect(subject).to eq([{ note_id: "1", count: 1 }])
        end
      end

      context "ノートごとに複数ログが存在する場合" do
        let(:logs) { [{ note_id: 1, date_at: Time.now.ago(1.minutes).utc }, { note_id: 1, date_at: Time.now.ago(2.minutes).utc }, { note_id: 2, date_at: Time.now.ago(3.minutes).utc }, { note_id: 2, date_at: Time.now.ago(4.minutes).utc }, { note_id: 2, date_at: Time.now.ago(5.minutes).utc }] }

        before do
          create_log(user, logs)
          travel 1.hours
        end

        it "ソートされた状態でデータが返る" do
          expect(subject).to eq([{ note_id: "2", count: 3 }, { note_id: "1", count: 2 }])
        end
      end
    end
  end
end
