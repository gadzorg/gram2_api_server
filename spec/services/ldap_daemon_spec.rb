require 'rails_helper'

RSpec.describe LdapDaemon, type: :service do

  fake(:message_sender) { GorgMessageSender }
  
  it "request a message sending to the message sender" do
    acc=FactoryGirl.build(:master_data_account, id_soce: 1234)
    ld=LdapDaemon.new(message_sender: message_sender)
    ld.request_account_update(acc)
    expect(message_sender).to have_received.send_message({id_soce: "1234"}, 'request.ldapd.update')
  end


end
