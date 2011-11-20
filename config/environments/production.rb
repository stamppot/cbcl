# Settings specified here will take precedence over those in config/environment.rb

puts "Starting in Production mode"
# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Enable threaded mode
# config.threadsafe!

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
# config.action_controller.page_cache_directory = RAILS_ROOT + "/public/cache"
config.action_view.cache_template_loading = true

# config.action_view.cache_asset_timestamps = true

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# http://code.google.com/p/super-exception-notifier/
# defaults to exception.notifier@default.com
# ExceptionNotifier.sender_address =
#   %("CBCL Application Error" <stamppot@gmail.com>)

# defaults to "[ERROR] "
# ExceptionNotifier.email_prefix = "[APP-#{RAILS_ENV.capitalize} ERROR] "

#defaults to false - meaning by default it sends email.  Setting true will cause it to only render the error pages, and NOT email.
# ExceptionNotifier.render_only = false

#defaults to %W( 405 500 503 )
# ExceptionNotifier.send_email_error_codes = %W( 400 403 404 405 410 500 501 503 )

#     defaults to: %("Exception Notifier" <exception.notifier@default.com>)
# ExceptionNotifier.sender_address = %("CBCL #{RAILS_ENV.capitalize} Error" <errors@cbcl-sdu.dk>)

#defaults explained further down in detail
# ExceptionNotifier.view_path = 'app/views/error'

#defaults explained further down in detail
# self.http_error_codes = { "400" => "Bad Request", "500" => "Internal Server Error" }

#defaults explained further down in detail
# self.rails_error_classes = { NameError => "503" }