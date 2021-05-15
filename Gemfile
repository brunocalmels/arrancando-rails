source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.3"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 6.0.0"

# Use postgresql as the database for Active Record
gem "pg", ">= 0.18", "< 2.0"
gem "geocoder"

gem "fcm"

# Use Puma as the app server
gem "puma", "~> 3.11"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", "~> 4.0"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"
# Use Redis adapter to run Action Cable in production
gem "redis"
# Use Active Model has_secure_password
gem "bcrypt", "~> 3.1.7"

# Use Active Storage variant
gem "image_processing", "~> 1.2"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.2", require: false

gem "actiontext"
gem "devise"
gem "factory_bot_rails"
gem "faker"
gem "jwt"
gem "simple_command"
gem "haml"
# gem 'rails_bootstrap_navbar'
gem "pundit"
gem "kaminari"
gem "filterrific"
gem "mini_magick"
gem "omniauth-google-oauth2"
gem "signet"
gem "rinku"
gem "actionpack-action_caching"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  # gem "rspec-rails" # Comentado por issue https://github.com/rails/rails/issues/35417
  gem "rspec-rails", git: "https://github.com/rspec/rspec-rails", branch: "4-0-dev"
  gem "rails-controller-testing"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.0.5", "< 3.2"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "annotate", ">= 2.5.0"
  gem "awesome_print"
  gem "better_errors"
  gem "binding_of_caller"
  gem "guard"
  gem "guard-livereload"
  gem "rack-livereload"
  gem "overcommit", ">= 0.37.0", require: false
  gem "rubocop", ">= 0.53.0", require: false
  gem "rubocop-performance"
  # gem 'dotenv'
  gem "foreman"
  gem "rb-readline"
  gem "webdrivers"
end

group :production do
  gem "aws-sdk-s3"
  gem "activerecord-postgis-adapter"
  gem "newrelic_rpm"
  gem "rack-timeout"
  gem "barnes"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
