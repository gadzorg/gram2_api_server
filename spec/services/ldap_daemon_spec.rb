require 'rails_helper'

RSpec.describe LdapDaemon, type: :service do

  fake(:message_sender) { GorgMessageSender }
  
  it "request a message sending to the message sender for account update" do
    acc=FactoryGirl.build(:master_data_account, id_soce: 1234)
    ld=LdapDaemon.new(message_sender: message_sender)
    ld.request_account_update(acc)
    expect(message_sender).to have_received.send_message({account: {uuid: acc.uuid.to_s}}, 'request.ldapd.update')
  end

  it "request a message sending to the message sender for group update" do
    group=FactoryGirl.build(:master_data_group, short_name: "test_group")
    ld=LdapDaemon.new(message_sender: message_sender)
    ld.request_group_update(group)
    expect(message_sender).to have_received.send_message({group: {uuid: group.uuid.to_s}}, 'request.ldapd.update')
  end

  it "request a message sending to the message sender for role update" do
    role=FactoryGirl.build(:master_data_role, name: "test_role", application: "test_app")
    ld=LdapDaemon.new(message_sender: message_sender)
    ld.request_role_update(role)
    expect(message_sender).to have_received.send_message({role: {uuid: role.uuid.to_s}}, 'request.ldapd.update')
  end
end
