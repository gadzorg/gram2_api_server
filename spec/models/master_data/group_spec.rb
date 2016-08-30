require 'rails_helper'

RSpec.describe MasterData::Group, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  it "has a valid factory" do
    expect(FactoryGirl.build(:master_data_group)).to be_valid
  end

  it "has an empty database" do
    expect(MasterData::Group.count).to eq(0)
  end

  it "validate presence of a uuid"
  it "contain name"
  it "contain short_name"

  describe "after_save" do
    fake(:message_sender) { GorgMessageSender }
    it { is_expected.to callback(:request_ldap_sync).after(:save) }
    it "send ldap maj request" do
      group=FactoryGirl.create(:master_data_group)
      ld = LdapDaemon.new(message_sender: message_sender)
      group.request_ldap_sync(ld)
      expect(message_sender).to have_received.send_message({group: {uuid: group.uuid}}, 'request.ldapd.group.update')
    end
  end
end
