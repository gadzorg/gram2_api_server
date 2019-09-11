require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GorgGramApiServer2
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths << Rails.root.join('lib/gorg_rabbitmq_notifier')
  end
end

#Manager multiple databases
db_conf = YAML::load(File.open(File.join(Rails.root,'config','database.yml')))

require File.expand_path('config/extra_config.rb',Rails.root)

RABBITMQ_CONFIG=ExtraConfig.new(File.expand_path("config/rabbitmq.yml",Rails.root),"RABBITMQ")
