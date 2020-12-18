require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
require 'influxdb-client'
# require "sprockets/railtie"
# require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # lib読み込み
    config.paths.add 'lib', eager_load: true

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.generators do |g|
      g.assets false
      g.helper false
      g.decorator false
      g.test_framework :rspec,
                       decorator_specs: false,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false
    end
    # i18nの設定
    config.i18n.default_locale = :ja
    config.time_zone = 'Tokyo'
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

    yaml_file = YAML.safe_load(ERB.new(Rails.root.join('config', 'config.yml').read).result)['study_book']
    yaml_file.merge! YAML.load_file(Rails.root.join('config', 'local_config.yml'))['study_book'] if File.exist?(Rails.root.join('config', 'local_config.yml'))
    config.influxdb = yaml_file["influxdb"]
  end
end
