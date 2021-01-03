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

  def number_read_per_note(limit)
    result = get_number_read_per_note
    if result.present?
      result.map { |group| { note_id: group[1].records[0].values["note_id"], count: group[1].records[0].value || 0 } }
            .sort_by { |x| x[:count] }
            .last(limit)
            .reverse
    else
      []
    end
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

  def get_number_read_per_note
    query = "from(bucket: \"#{@client.bucket}\")
      |> range(start: 0)
      |> filter(fn: (r) =>
          r._field == \"type\" and
          r._value == \"read_note\")
      |> group(columns: [\"note_id\"])
      |> count(column: \"_value\")"
    @client.query_api.query(query: query)
  end
end
