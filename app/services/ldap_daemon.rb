require 'gorg_message_sender'

class LdapDaemon

  def initialize(message_sender: nil)
    @message_sender=message_sender || GorgMessageSender.new
  end

  def request_account_update(account)
    msg={account: {uuid: account.uuid.to_s}}
    @message_sender.send_message(msg, 'request.ldapd.update')
  end

  def request_group_update(group)
    msg={group: {uuid: group.uuid.to_s}}
    @message_sender.send_message(msg, 'request.ldapd.update')
  end

  def request_role_update(role)
    msg={role: {uuid: role.uuid.to_s}}
    @message_sender.send_message(msg, 'request.ldapd.update')
  end

end