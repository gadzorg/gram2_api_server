GorgMessageSender.configure do |c|

  # Id used to set the event_sender_id
  c.application_id = ENV["RABBITMQ_SENDER_ID"]||"gram"

  # RabbitMQ network and authentification
  #c.host = "localhost" 
  c.host = ENV["RABBITMQ_HOST"]
  #c.port = 5672 
  c.port = ENV["RABBITMQ_PORT"]
  #c.vhost = "/"
  c.vhost = ENV["RABBITMQ_VHOST"]
  #c.user = nil
  c.user = ENV["RABBITMQ_USER"]
  #c.password = nil
  c.password = ENV["RABBITMQ_PASSWORD"]

  # Exchange configuration
  #c.exchange_name ="exchange"
  c.exchange_name = ENV["RABBITMQ_EXCHANGE"]||"agoram_event_exchange"

  #c.durable_exchange= true
end