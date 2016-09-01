class GorgRabbitmqNotifier::MessagesQueue

  def initialize
    @messages=[]
  end

  def messages
    @messages
  end

  def queue(message)
    if old=find_same_object_message(message)
      old.merge(message)
    else
      @messages << message
    end
  end

  def find_same_object_message message
    @messages.select{|m|m.same_object? message}.first
  end

end