# frozen_string_literal: true

require Rails.root.join("config", "extra_config")

RABBITMQ_CONFIG =
  ExtraConfig.new(Rails.root.join("config", "rabbitmq.yml"), "RABBITMQ")
