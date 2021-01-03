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

      def create_log(user, logs)
        ReadNoteLog.new(user.id).write_read_note_log(logs)
      end

      before do
        travel_to time
      end

      context "データが1つの場合" do
        let(:now_time) { "2020-04-01Z01:00:00+0000" }
        let(:logs) { [{ note_id: note_id }] }

        before do
          create_log(user, logs)
          travel_to now_time
        end

        it "1が返る" do
          expect(subject).to eq(1)
        end
      end

      context "他ユーザのデータが混在する場合" do
        let(:now_time) { "2020-04-01Z01:00:00+0000" }
        let(:logs) { [{ note_id: note_id }] }
        let(:other_user) { create(:user) }

        before do
          create_log(user, logs)
          create_log(other_user, logs)
          travel_to now_time
        end

        it "2が返る" do
          expect(subject).to eq(2)
        end
      end
    end
  end
end
