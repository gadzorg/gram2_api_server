require 'rails_helper'

RSpec.describe LdapDaemon, type: :service do

  fake(:message_sender) { GorgMessageSender }

  it "request a message sending to the message sender for account update" do
    acc = build(:master_data_account, id_soce: 1234)
    ld=LdapDaemon.new(message_sender: message_sender)
    ld.request_account_update(acc)
    expect(message_sender).to have_received.send_message({uuid: acc.uuid.to_s}, 'request.ldapd.account.update')
  end

  it "request a message sending to the message sender for group update" do
    group = build(:master_data_group, short_name: "test_group")
    ld=LdapDaemon.new(message_sender: message_sender)
    ld.request_group_update(group)
    expect(message_sender).to have_received.send_message({uuid: group.uuid.to_s}, 'request.ldapd.group.update')
  end
end
