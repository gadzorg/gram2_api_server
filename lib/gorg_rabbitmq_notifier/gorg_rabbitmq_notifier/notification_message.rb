class GorgRabbitmqNotifier::NotificationMessage

  class InvalidNotificationMessage < StandardError;  end

  attr_accessor :resource_type
  attr_accessor :action
  attr_accessor :resource_id_attribute
  attr_accessor :resource_id_value
  attr_accessor :changes

  def initialize(opts={})
    @resource_type = opts[:resource_type].to_s
    @action = opts[:action].to_s
    @resource_id_attribute = opts[:resource_id_attribute].to_s
    @resource_id_value = opts[:resource_id_value].to_s
    @changes = opts[:changes]
  end

  def valid?
    @resource_type && @action && @resource_id_attribute && @resource_id_value
  end

  def commit
    if valid?
      GorgRabbitmqNotifier.deliver(self)
      return true
    else
      return false
    end
  end

  def commit!
    raise InvalidNotificationMessage unless commit
  end

  def routing_key
    "notify.#{@resource_type}.#{@action}"
  end

  def data
    {
      @resource_id_attribute => @resource_id_value,
      "changes" => @changes
    }
  end

  def to_rabbitmq_message
    {
      routing_key: routing_key,
      content: GorgMessageSender.new.to_message(data, routing_key)
    }
  end

  def same_object? message
    message.resource_type == self.resource_type && message.resource_id_attribute == self.resource_id_attribute && message.resource_id_value == self.resource_id_value
  end

  def merge(message)
    self.action = message.action unless self.action=="created"
    self.changes = merge_changes_hash(self.changes, message.changes)
  end

  def merge_changes_hash(_old_h,new_h)
    old_h=_old_h.dup
    new_h.each_pair do |k,v|
      old_value = old_h[k]

      old_h[k]= case old_value.class.to_s
      when "NilClass"
        v
      when "Hash"
        if v[:add]||v[:del]
          res={}
          res[:add]= (old_value[:add]||[])+v[:add] if v[:add]
          res[:del]= (old_value[:del]||[])+v[:del] if v[:del]
          res
        else
          merge_changes_hash(old_value,v)
        end
      when "Array"
        [old_value[0],v[1]]
      end
    end
    old_h
  end

end

#"changes"=>{"uuid"=>[nil, "ed887d4f-4b21-4523-bb7e-0e28ca33e31b"], "hruid"=>[nil, "mallie.spinka.1916"]}
#"changes"=>{"alias"=>{"add"=>["mallie.spinka.1916"]}}
#"changes"=>{"alias"=>{"add"=>["307014"]}}
#"changes"=>{"hruid"=>["mallie.spinka.1916","plopplopplop""]}

#result => {"uuid"=>[nil, "ed887d4f-4b21-4523-bb7e-0e28ca33e31b"], "hruid"=>[nil, "plopplopplop"], "alias": {add: ["mallie.spinka.1916",307014"]}},