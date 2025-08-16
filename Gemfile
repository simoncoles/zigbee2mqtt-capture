source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.0"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"
# Use Redis adapter to run Action Cable in production
gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mswin mswin64 mingw x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mswin mswin64 mingw x64_mingw ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Highlight the fine-grained location where an error occurred [https://github.com/ruby/error_highlight]
  # Removing this because this is happening in the build
  # /opt/hostedtoolcache/Ruby/3.1.2/x64/lib/ruby/gems/3.1.0/gems/bundler-2.5.3/lib/bundler/runtime.rb:304:in `check_for_activated_spec!': You have already activated error_highlight 0.3.0, but your Gemfile requires error_highlight 0.6.0. Since error_highlight is a default gem, you can either remove your dependency on it or try updating to a newer version of bundler that supports error_highlight as a default gem. (Gem::LoadError)
  # gem "error_highlight", ">= 0.4.0", platforms: [:ruby]

  # Annotate things
  gem "annotaterb"
  
  # Process management for development
  gem "foreman"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end

# For environment variables
gem "dotenv", groups: [ :development, :test ]

# MQTT
gem "mqtt"

# SQLite is the default database
gem "sqlite3"
# But we also support Postgres and MySQL
gem "pg", "~> 1.5"
gem "mysql2", "~> 0.5"

# Sensible logging
gem "lograge"

# Error reporting
gem "appsignal"

# Deployment
gem "kamal"

# Quick and easy admin interface
gem "madmin", "~> 2.0"
