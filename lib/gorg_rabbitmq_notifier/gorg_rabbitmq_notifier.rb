class GorgRabbitmqNotifier
  class << self

  def deliver message
    if message_queues.any?
      message_queues.last.queue message
    else
      perform_delivery message
    end
  end

  def message_queues
    @messages_queues ||= []
  end

  def batch
    queue=GorgRabbitmqNotifier::MessagesQueue.new
    message_queues<<queue

    yield

    message_queues.pop
  
    queue.messages.each do |m|
      deliver m
    end
    

  end


  def perform_delivery message
    puts "Send #{message.routing_key}"
    message_sender.send_message(message.data, message.routing_key)
  end

  private

    def message_sender
      @message_sender||=GorgMessageSender.new()
    end

  end
end