require 'gorg_message_sender'

class LdapDaemon

  def initialize(message_sender: nil)
    @message_sender=message_sender || GorgMessageSender.new
  end

  def request_account_update(account)
    msg={account: {id_soce: account.id_soce.to_s}}
    @message_sender.send_message(msg, 'request.ldapd.update')
  end

  def request_group_update(group)
    msg={group: {short_name: group.short_name.to_s}}
    @message_sender.send_message(msg, 'request.ldapd.update')
  end

  def request_role_update(role)
    msg={role: {name: role.name.to_s, application: role.application.to_s}}
    @message_sender.send_message(msg, 'request.ldapd.update')
  end

end