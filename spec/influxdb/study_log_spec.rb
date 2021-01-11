require 'rails_helper'

RSpec.describe "StudyLogSpec", use_influx: true do
  let(:user) { create(:user) }

  describe ".write_study_log" do
    subject { StudyLog.new(user.id).write_study_log(logs) }

    context '時間を指定せずにログを書き込んだ時' do
      let(:logs) { [{ note_id: 1, word_count: 100 }] }

      it "trueが返ること" do
        expect(subject).to eq(true)
      end
    end

    context '時間を指定してログを書き込んだ時' do
      let(:logs) { [{ note_id: 1, word_count: 100, date_at: Time.now.ago(1.days).utc }] }

      it "trueが返ること" do
        expect(subject).to eq(true)
      end
    end

    context '新規作成フラグを指定してログを書き込んだ時' do
      let(:logs) { [{ note_id: 1, word_count: 100, date_at: Time.now.ago(1.days).utc, is_create: true }] }

      it "trueが返ること" do
        expect(subject).to eq(true)
      end
    end
  end

  describe ".user_monthly_study_length" do
    subject { StudyLog.new(user.id).user_monthly_study_length }

    context "データが存在しない場合" do
      it "0が13要素の配列が返る" do
        expect(subject).to eq([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
      end
    end

    context "データが存在する場合" do
      let(:time) { "2020-04-01Z00:00:00+0000" }

      def create_log(user, logs)
        StudyLog.new(user.id).write_study_log(logs)
      end

      before do
        travel_to time
      end

      context "データが1つの場合" do
        let(:now_time) { "2020-04-01Z01:00:00+0000" }
        let(:logs) { [{ note_id: 1, word_count: 100 }] }

        before do
          create_log(user, logs)
          travel_to now_time
        end

        it "今月のデータに100のデータが返る" do
          expect(subject).to eq([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100])
        end
      end

      context "同時刻のデータが2つある場合" do
        let(:now_time) { "2020-04-01Z01:00:00+0000" }
        let(:logs) { [{ note_id: 1, word_count: 100, date_at: Time.parse(now_time) }, { note_id: 2, word_count: 200, date_at: Time.parse(now_time) }] }

        before do
          create_log(user, logs)
          travel_to now_time
        end

        it "今月のデータに300のデータが返る" do
          expect(subject).to eq([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 300])
        end
      end

      context "別区分のデータがある場合" do
        let(:now_time) { "2020-04-01Z01:00:00+0000" }
        let(:logs) { [{ note_id: 1, word_count: 200, date_at: Time.parse(now_time).ago(1.month) }, { note_id: 2, word_count: 300, date_at: Time.parse(now_time) }] }

        before do
          create_log(user, logs)
          travel_to now_time
        end

        it "別区分も反映されたデータが返る" do
          expect(subject).to eq([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 200, 300])
        end
      end

      context "他ユーザのデータが混在する場合" do
        let(:now_time) { "2020-04-01Z01:00:00+0000" }
        let(:logs) { [{ note_id: 1, word_count: 100 }] }
        let(:other_user) { create(:user) }

        before do
          create_log(user, logs)
          create_log(other_user, logs)
          travel_to now_time
        end

        it "今月のデータに100のデータが返る" do
          expect(subject).to eq([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100])
        end
      end
    end
  end

  describe ".user_monthly_create_count" do
    subject { StudyLog.new(user.id).user_monthly_create_count }

    context "データが存在しない場合" do
      it "0が13要素の配列が返る" do
        expect(subject).to eq([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
      end
    end

    context "データが存在する場合" do
      let(:time) { "2020-04-01Z00:00:00+0000" }

      def create_log(user, logs)
        StudyLog.new(user.id).write_study_log(logs)
      end

      before do
        travel_to time
      end

      context "create trueのデータが1つの場合" do
        let(:now_time) { "2020-04-01Z01:00:00+0000" }
        let(:logs) { [{ note_id: 1, word_count: 100, is_create: 'true' }] }

        before do
          create_log(user, logs)
          travel_to now_time
        end

        it "今月のデータに1のデータが返る" do
          expect(subject).to eq([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1])
        end
      end

      context "create trueとfalseの2つのデータがある場合" do
        let(:now_time) { "2020-04-01Z01:00:00+0000" }
        let(:logs) { [{ note_id: 1, word_count: 100, date_at: Time.parse(now_time), is_create: 'true' }, { note_id: 2, word_count: 200, date_at: Time.parse(now_time), is_create: 'false' }] }

        before do
          create_log(user, logs)
          travel_to now_time
        end

        it "今月のデータに300のデータが返る" do
          expect(subject).to eq([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1])
        end
      end

      context "create trueの同時刻のデータが2つある場合" do
        let(:now_time) { "2020-04-01Z01:00:00+0000" }
        let(:logs) { [{ note_id: 1, word_count: 100, date_at: Time.parse(now_time), is_create: 'true' }, { note_id: 2, word_count: 200, date_at: Time.parse(now_time), is_create: 'true' }] }

        before do
          create_log(user, logs)
          travel_to now_time
        end

        it "今月のデータに300のデータが返る" do
          expect(subject).to eq([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2])
        end
      end

      context "create trueの別区分のデータがある場合" do
        let(:now_time) { "2020-04-01Z01:00:00+0000" }
        let(:logs) { [{ note_id: 1, word_count: 200, date_at: Time.parse(now_time).ago(1.month), is_create: 'true' }, { note_id: 2, word_count: 300, date_at: Time.parse(now_time), is_create: 'true' }] }

        before do
          create_log(user, logs)
          travel_to now_time
        end

        it "別区分も反映されたデータが返る" do
          expect(subject).to eq([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1])
        end
      end

      context "create trueの他ユーザのデータが混在する場合" do
        let(:now_time) { "2020-04-01Z01:00:00+0000" }
        let(:logs) { [{ note_id: 1, word_count: 100, is_create: 'true' }] }
        let(:other_user) { create(:user) }

        before do
          create_log(user, logs)
          create_log(other_user, logs)
          travel_to now_time
        end

        it "今月のデータに100のデータが返る" do
          expect(subject).to eq([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1])
        end
      end
    end
  end

  describe ".user_monthly_update_count" do
    subject { StudyLog.new(user.id).user_monthly_update_count }

    context "データが存在しない場合" do
      it "0が13要素の配列が返る" do
        expect(subject).to eq([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
      end
    end

    context "データが存在する場合" do
      let(:time) { "2020-04-01Z00:00:00+0000" }

      def create_log(user, logs)
        StudyLog.new(user.id).write_study_log(logs)
      end

      before do
        travel_to time
      end

      context "create falseのデータが1つの場合" do
        let(:now_time) { "2020-04-01Z01:00:00+0000" }
        let(:logs) { [{ note_id: 1, word_count: 100, is_create: 'false' }] }

        before do
          create_log(user, logs)
          travel_to now_time
        end

        it "今月のデータに1のデータが返る" do
          expect(subject).to eq([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1])
        end
      end

      context "create trueとfalseの2つのデータがある場合" do
        let(:now_time) { "2020-04-01Z01:00:00+0000" }
        let(:logs) { [{ note_id: 1, word_count: 100, date_at: Time.parse(now_time), is_create: 'true' }, { note_id: 2, word_count: 200, date_at: Time.parse(now_time), is_create: 'false' }] }

        before do
          create_log(user, logs)
          travel_to now_time
        end

        it "今月のデータに300のデータが返る" do
          expect(subject).to eq([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1])
        end
      end

      context "create falseの同時刻のデータが2つある場合" do
        let(:now_time) { "2020-04-01Z01:00:00+0000" }
        let(:logs) { [{ note_id: 1, word_count: 100, date_at: Time.parse(now_time), is_create: 'false' }, { note_id: 2, word_count: 200, date_at: Time.parse(now_time), is_create: 'false' }] }

        before do
          create_log(user, logs)
          travel_to now_time
        end

        it "今月のデータに300のデータが返る" do
          expect(subject).to eq([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2])
        end
      end

      context "create falseの別区分のデータがある場合" do
        let(:now_time) { "2020-04-01Z01:00:00+0000" }
        let(:logs) { [{ note_id: 1, word_count: 200, date_at: Time.parse(now_time).ago(1.month), is_create: 'false' }, { note_id: 2, word_count: 300, date_at: Time.parse(now_time), is_create: 'false' }] }

        before do
          create_log(user, logs)
          travel_to now_time
        end

        it "別区分も反映されたデータが返る" do
          expect(subject).to eq([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1])
        end
      end

      context "create falseの他ユーザのデータが混在する場合" do
        let(:now_time) { "2020-04-01Z01:00:00+0000" }
        let(:logs) { [{ note_id: 1, word_count: 100, is_create: 'false' }] }
        let(:other_user) { create(:user) }

        before do
          create_log(user, logs)
          create_log(other_user, logs)
          travel_to now_time
        end

        it "今月のデータに100のデータが返る" do
          expect(subject).to eq([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1])
        end
      end
    end
  end

  describe ".total_edit_word_count" do
    subject { StudyLog.new(user.id).total_edit_word_count }

    let(:time) { "2020-04-01Z00:00:00+0000" }

    before do
      travel_to time
    end

    context "ログデータが存在しない場合" do
      it "0が返る" do
        expect(subject).to eq(0)
      end
    end

    context "ログデータが存在する場合" do
      let(:now_time) { "2020-04-01Z01:00:00+0000" }

      before do
        StudyLog.new(user.id).write_study_log(logs)
        travel_to now_time
      end

      context "1件の場合" do
        let(:logs) { [{ note_id: 1, word_count: 100 }] }

        it "100が返る" do
          expect(subject).to eq(100)
        end
      end

      context "2件の場合" do
        let(:logs) { [{ note_id: 1, word_count: 200, date_at: Time.parse(now_time).ago(1.month) }, { note_id: 2, word_count: 300, date_at: Time.parse(now_time) }] }

        it "500が返る" do
          expect(subject).to eq(500)
        end
      end
    end
  end
end
