require_relative 'boot'

require 'rails'

require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)

module Grimonium
  class Application < Rails::Application
    config.load_defaults 5.2

    config.autoload_paths   << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join('lib')

    config.time_zone = 'Asia/Tokyo'
    config.active_record.default_timezone = :local

    config.i18n.default_locale = :ja
  end
end
