source "https://rubygems.org"

ruby File.read(".ruby-version").strip

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "5.2.3"
gem "bootsnap", require: false

# gem 'mysql2', '~> 0.3.20'
gem "pg", "< 1" # 1.0 required postgresql > 9.2
# gems for haml
gem "haml-rails"
# Use SCSS for stylesheets
gem "sass-rails"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier"

# See https://github.com/rails/execjs#readme for more supported runtimes
gem "therubyracer", platforms: :ruby

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem "turbolinks"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder"
# bundle exec rake doc:rails generates the API under doc/api.
gem "sdoc", group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem "active_model_serializers"

gem "gorg_message_sender", git: "https://github.com/gadzorg/gorg_message_sender", ref: "v1.4.6"
gem "gorg_service", "< 5" # v5 changes MessageHandler structure

gem "redis"
gem "activerecord-import"

# Auth
gem "devise"
gem "devise-encryptable"
gem "simple_token_authentication"

# Authorization
gem "pundit"

# Roles
gem "rolify"

gem "factory_bot_rails"
gem "faker"

# pagination
gem "kaminari"

# Performances
gem "scout_apm"

group :production do
  #HEROKU
  gem "heroku_secrets", git: "https://github.com/alexpeattie/heroku_secrets"
  gem "rails_12factor"
  gem "puma"
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug"
  gem "database_cleaner"
  gem "better_errors"
  gem "bogus"

  gem "pry-byebug"
  gem "pry-rails"
end

group :development do
  gem "listen", require: false

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem "web-console"
  gem "binding_of_caller"

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
end

group :test do
  gem "simplecov", require: false
  gem "shoulda-matchers"
  gem "rspec-rails"
  gem "shoulda-callback-matchers"
end
