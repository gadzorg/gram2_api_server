require 'gorg_message_sender'

class LdapDaemon

  def initialize(message_sender: nil)
    @message_sender=message_sender || GorgMessageSender.new
  end

  def request_account_update(account)
    msg={id_soce: account.id_soce}
    @message_sender.send_message(msg, 'request.ldapd.update')
  end

end