class GorgRabbitmqNotifier
  class << self

  def deliver messages

    messages=[messages] unless messages.is_a? Array

    if message_queues.any?
      messages.each{|m| message_queues.last.queue m}
    else
      perform_delivery messages
    end
  end

  def message_queues
    @messages_queues ||= []
  end


  # Store notification end send them at the end. Merge notification concerning the same object
  #
  ## Usage
  #
  # GorgRabbitmqNotifier.batch
  #
  #   #Do things that create notifications
  #
  # end
  def batch
    queue=GorgRabbitmqNotifier::MessagesQueue.new
    message_queues<<queue

    yield

    message_queues.pop
  
    deliver queue.messages
  end

  def perform_delivery messages
    Rails.logger.debug "Send #{messages.count} messages"
    message_sender.send_batch_raw(messages.map{|m|m.to_rabbitmq_message})
  end

  private

    def message_sender
      @message_sender||=GorgMessageSender.new()
    end

  end
end