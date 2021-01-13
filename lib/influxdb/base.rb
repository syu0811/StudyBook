module Influxdb
  class Base
    def initialize(user_id)
      @client = InfluxdbClient.new(user_id)
    end

    private

    def write_api(args)
      @client.write_api.write(data: args[:data])
    end
  end
end
