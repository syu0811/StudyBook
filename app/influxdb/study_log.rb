class StudyLog < Influxdb::Base
  STATUS_CODE_OF_NO_CONTENT = "204".freeze

  # logsは、note_idとword_countのハッシュの配列
  def write_study_log(logs = [])
    return unless call_write_api(logs)

    true
  rescue StandardError
    false
  end

  # 当月を含む過去12ヶ月間(12ヶ月前は含む)
  def user_monthly_study_length
    result = get_logs_by_range(Time.zone.now.beginning_of_day.ago(1.year).iso8601, '1mo')
    result.present? ? result : 13.times.map { 0 }
  end

  def get_logs_by_range(start_date, every)
    query = "from(bucket: \"#{@client.bucket}\")
      |> range(start: #{start_date}, stop: now())
      |> filter(fn: (r) =>
          r._measurement == \"#{@client.user_id}\")
      |> window(every: #{every}, createEmpty: true)
      |> sum()"
    @client.query_api.query(query: query).map do |section|
      section[1].records[0].value || 0
    end
  end

  private

  def call_write_api(logs, user_id)
    write_api(data: import_study_data(logs, user_id))&.code == STATUS_CODE_OF_NO_CONTENT
  end

  def import_study_data(logs)
    [].tap do |arr|
      logs.each do |log|
        log[:date_at] ||= Time.now.utc
        arr << InfluxDB2::Point.new(name: @client.user_id)
                               .add_tag('note_id', log[:note_id])
                               .add_field('word_count', log[:word_count])
                               .time(log[:date_at], InfluxDB2::WritePrecision::NANOSECOND)
      end
    end
  end
end
