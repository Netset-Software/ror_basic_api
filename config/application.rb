require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RorBasicApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.raise_delivery_errors = true

    # SMTP settings for gmail

    config.action_mailer.smtp_settings = {
      :enable_starttls_auto => true,
      :address => "smtp.gmail.com",
      :port => 587,
      :domain => "gmail.com",
      :authentication => :login,
      :user_name => "developeronwork6@gmail.com",
      :password => "nmlsfhytmftdthyh",
    }


  end
end
