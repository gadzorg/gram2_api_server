require 'rails_helper'

RSpec.describe MasterData::Role, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:master_data_role)).to be_valid
  end

  it "has an empty database" do
    expect(MasterData::Role.count).to eq(0)
  end

  it "validate presence of a uuid"
  it "contain name"
  it "contain application"
  it "contain description"

  describe "after_save" do
    fake(:message_sender) { GorgMessageSender }
    it { is_expected.to callback(:request_ldap_sync).after(:save) }
    it "send ldap maj request" do
      role=FactoryGirl.create(:master_data_role)
      ld = LdapDaemon.new(message_sender: message_sender)
      role.request_ldap_sync(ld)
      expect(message_sender).to have_received.send_message({role: {uuid: role.uuid}}, 'request.ldapd.update')
    end
  end
end

