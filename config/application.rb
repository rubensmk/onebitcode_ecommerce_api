require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"

Bundler.require(*Rails.groups)

module EcommerceApi
  class Application < Rails::Application
    config.load_defaults 6.0

    # I18n config
    config.i18n.load_path += Dir[Rails.root.join('config/locales/**/*.{rb,yml}')]
    config.i18n.default_locale = :'pt-BR'

    config.api_only = false
    config.session_store :cookie_store, key: '_interslice_session'

    # customer validators
    config.autoload_paths += %W["#{config.root}/app/validators/"]
  end
end
