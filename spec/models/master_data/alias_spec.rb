require 'rails_helper'

RSpec.describe MasterData::Alias, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:master_data_alias)).to be_valid
  end

  it "has an empty database" do
    expect(MasterData::Alias.count).to eq(0)
  end

  it "invalidate duplicates names" do
    alias1=FactoryGirl.create(:master_data_alias, name: "test_alias1")
    alias2=FactoryGirl.build(:master_data_alias, name: "test_alias1")
    expect(alias2.valid?).to eq(false)
  end

  describe "after_save" do
    fake(:message_sender) { GorgMessageSender }
    it { is_expected.to callback(:sync_attached_account_to_ldap).after(:save) }
  end

end