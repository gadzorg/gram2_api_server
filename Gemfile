source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~>4.2'
# gem 'mysql2', '~> 0.3.20'
gem 'pg'
# gems for haml
gem "haml-rails", "~> 0.9"
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'active_model_serializers', '~> 0.10.0'

gem 'gorg_message_sender'

# Auth
gem 'devise'
gem 'devise-encryptable'
gem 'simple_token_authentication', '~> 1.0' # see semver.org

# Authorization
gem 'pundit'

# Roles
gem 'rolify', '~> 5.1'


group :production do
  #HEROKU
  gem 'heroku_secrets', github: 'alexpeattie/heroku_secrets'
  gem 'rails_12factor'

end


group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'database_cleaner'
  gem 'better_errors'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'bogus'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  gem 'shoulda-matchers', '~>3.0'
  gem 'rspec-rails'
  gem 'vigia'
  gem 'shoulda-callback-matchers', '~> 1.1', '>= 1.1.4'
end

