RSpec.shared_context "use influx", use_influx: true do
  before do
    Rails.configuration.influxdb["database"] = "study_book_test_db"
  end

  after do
    host = Rails.configuration.influxdb['host']
    database = Rails.configuration.influxdb["database"]
    user = Rails.configuration.influxdb['user']
    password = Rails.configuration.influxdb['password']
    system("curl -G '#{host}/query?db=#{database}&u=#{user}&p=#{password}' --data-urlencode 'q=DELETE FROM /.*/' > /dev/null 2>&1")
  end
end

RSpec.configure do |rspec|
  rspec.include_context "use influx", use_influx: true
end
