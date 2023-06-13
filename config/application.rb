require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AuthApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    

    #default time
    # for message_broadcast_job
    config.active_job.queue_adapter = :async


    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    # #for adding the cron path in rake
     config.autoload_paths += %W(#{config.root}/lib/tasks)
    # config.autoload_paths += Dir["#{config.root}/lib/tasks/"]
   

    
   

    #notifications 
    #config.autoload_paths += %W(#{config.root}/lib)

    # config.time_zone = "Central Time (US & Canada)"
    #config.time_zone = 'Asia/Kolkata'

    # config.eager_load_paths << Rails.root.join("extras")
    config.filter_parameters += [:password, :password_confirmation]
    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.session_store :cookie_store, key: '_interslice_session'
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use config.session_store, config.session_options
  end
end
