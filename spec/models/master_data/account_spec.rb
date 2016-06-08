require 'rails_helper'

RSpec.describe MasterData::Account, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:master_data_account)).to be_valid
  end

  it "has an empty database" do
    expect(MasterData::Account.count).to eq(0)
  end

  describe "valid hruid" do 
    it "generate uniq hurid"
    it "contain promo for gadz"
    it "contraint ext for ext"
    it "contraint soce for soce"
    it "manage homonyms w/ same promo"
  end

  #email
  it {is_expected.to validate_presence_of :email}
  it {is_expected.to allow_value('prenom.nom@gadz.org').for(:email)}
  it {is_expected.not_to allow_value('prenom.nom.gadz.org').for(:email)}
  
  it {is_expected.to validate_presence_of :encrypted_password}
  it {is_expected.to validate_inclusion_of(:gender).in_array(['male','female'])}
  
  #id soce
  it "validate presence of :soce_id" do
    account=FactoryGirl.create(:master_data_account)
    account.soce_id=nil
    expect(account.valid?).to eq(false)
  end

   describe "validate that :soce_id is an integer" do
    it "invalidate strings in :soce_id" do
      account=FactoryGirl.create(:master_data_account)
      account.soce_id="string"
      expect(account.valid?).to eq(false)
    end

    it "invalidate non integer numbers in :soce_id" do
      account=FactoryGirl.create(:master_data_account)
      account.soce_id=157.211
      expect(account.valid?).to eq(false)
    end
  end

  describe "Soce_id auto_increment" do

    it "auto increment soce_id" do
      account1=FactoryGirl.create(:master_data_account)
      expect(FactoryGirl.create(:master_data_account).soce_id).to eq(account1.soce_id+1)
    end

    describe "update soce_id sequence when user input" do
      context "when user input greater than actual sequence" do
        it "update soce_id next value " do
          account1=FactoryGirl.create(:master_data_account)
          account2=FactoryGirl.create(:master_data_account, soce_id: account1.soce_id+10)
          expect(FactoryGirl.create(:master_data_account).soce_id).to eq(account1.soce_id+11)
        end
      end

      context "when user input lesser than actual sequence" do
        it "doens't update soce_id sequence when user input" do
          account1=FactoryGirl.create(:master_data_account)
          account2=FactoryGirl.create(:master_data_account, soce_id: account1.soce_id+10)
          account3=FactoryGirl.create(:master_data_account, soce_id: account1.soce_id+5)
          expect(FactoryGirl.create(:master_data_account).soce_id).to eq(account1.soce_id+11)
        end
      end
    end
  end

  #info trads
  it "valid buque without special char"
  it "invalid buque with special char"
  it "valid buque zaloeil with special char"

end
