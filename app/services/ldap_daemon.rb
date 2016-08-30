require 'gorg_message_sender'

class LdapDaemon

  def initialize(message_sender: nil)
    @message_sender=message_sender || GorgMessageSender.new
  end

  def request_account_update(account)
    msg={uuid: account.uuid.to_s}
    send_message(msg, 'request.ldapd.account.update')
  end
  
  def request_account_delete(account)
    msg={uuid: account.uuid.to_s}
    send_message(msg, 'request.ldapd.account.delete')
  end

  def request_group_update(group)
    msg={uuid: group.uuid.to_s}
    send_message(msg, 'request.ldapd.group.update')
  end
  
  def request_group_delete(group)
    msg={uuid: group.uuid.to_s}
    send_message(msg, 'request.ldapd.group.delete')
  end

  def request_role_update(role)
  #   msg={role: {uuid: role.uuid.to_s}}
  #   send_message(msg, 'request.ldapd.update')
      Rails.logger.warn "DEPRECATED request_role_update : Roles are not regstered in LDAP anymore"
  end

  private

  def send_message(msg, routing_key)
    begin
      @message_sender.send_message(msg, routing_key)
      return true
    rescue Bunny::TCPConnectionFailedForAllHosts
      Rails.logger.error "Unable to connect to RabbitMQ server"
      return false
    end
  end

end
