module Influxdb
  class MockClient
    attr_reader :bucket, :company_guid, :write_api, :query_api

    def initialize(user_id)
      host     = Rails.configuration.influxdb["host"]
      username = Rails.configuration.influxdb["user"]
      password = Rails.configuration.influxdb["password"]
      retention_policy = 'autogen' # 保存期間無限
      @bucket = "#{Rails.configuration.influxdb['database']}/#{retention_policy}"
      client = InfluxDB2::Client.new(host, "#{username}:#{password}", bucket: @bucket, org: '-', use_ssl: false, precision: InfluxDB2::WritePrecision::NANOSECOND)
      @write_api = client.create_write_api
      @query_api = client.create_query_api
      @user_id = user_id.to_s
    end
  end
end
