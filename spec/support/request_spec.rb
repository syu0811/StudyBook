module Controllers
  module JsonHelper
    def response_json
      return if response.body.blank?

      JSON.parse response.body, symbolize_names: true
    end
  end
end

RSpec.configure do |config|
  config.include Controllers::JsonHelper, type: :request
end
