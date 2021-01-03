class ReadNoteLog < Influxdb::Base
  STATUS_CODE_OF_NO_CONTENT = "204".freeze

  # logsは、note_idだけの配列
  def write_read_note_log(logs = [])
    return unless call_write_api(logs)

    true
  rescue StandardError
    false
  end

  def total_read_note_count(note_id)
    get_total_read_note_count(note_id)
  end

  private

  def call_write_api(logs)
    write_api(data: import_read_note_data(logs))&.code == STATUS_CODE_OF_NO_CONTENT
  end

  def import_read_note_data(logs)
    [].tap do |arr|
      logs.each do |log|
        log[:date_at] ||= Time.now.utc
        arr << InfluxDB2::Point.new(name: @client.user_id)
                               .add_tag('note_id', log[:note_id])
                               .add_field('type', 'read_note')
                               .time(log[:date_at], InfluxDB2::WritePrecision::NANOSECOND)
      end
    end
  end

  def get_total_read_note_count(note_id)
    query = "from(bucket: \"#{@client.bucket}\")
      |> range(start: 0)
      |> filter(fn: (r) =>
          r.note_id == \"#{note_id}\" and
          r._field == \"type\" and
          r._value == \"read_note\")
      |> group()
      |> count()"
    result = @client.query_api.query(query: query)
    result.present? ? result[0].records[0].value : 0
  end
end
