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
 it {is_expected.to validate_uniqueness_of :email}
 it {is_expected.to allow_value('prenom.nom@gadz.org').for(:email)}
 it {is_expected.not_to allow_value('prenom.nom.gadz.org').for(:email)}

 it {is_expected.to validate_presence_of :password}
 it {is_expected.to validate_inclusion_of(:gender).in_array(['male','female'])}

 it "validate presence of a uuid"

 #id soce
  it "validate presence of :id_soce" do
    account=FactoryGirl.create(:master_data_account)
    account.id_soce=nil
    expect(account.valid?).to eq(false)
  end

   describe "validate that :id_soce is an integer" do
    it "invalidate strings in :id_soce" do
      account=FactoryGirl.create(:master_data_account)
      account.id_soce="string"
      expect(account.valid?).to eq(false)
    end

    it "invalidate non integer numbers in :id_soce" do
      account=FactoryGirl.create(:master_data_account)
      account.id_soce=157.211
      expect(account.valid?).to eq(false)
    end
  end

  describe "id_soce auto_increment" do

    it "auto increment id_soce" do
      account1=FactoryGirl.create(:master_data_account)
      expect(FactoryGirl.create(:master_data_account).id_soce).to eq(account1.id_soce+1)
    end

    describe "update id_soce sequence when user input" do
      context "when user input greater than actual sequence" do
        it "update id_soce next value " do
          account1=FactoryGirl.create(:master_data_account)
          account2=FactoryGirl.create(:master_data_account, id_soce: account1.id_soce+10)
          expect(FactoryGirl.create(:master_data_account).id_soce).to eq(account1.id_soce+11)
        end
      end

      context "when user input lesser than actual sequence" do
        it "doens't update id_soce sequence when user input" do
          account1=FactoryGirl.create(:master_data_account)
          account2=FactoryGirl.create(:master_data_account, id_soce: account1.id_soce+10)
          account3=FactoryGirl.create(:master_data_account, id_soce: account1.id_soce+5)
          expect(FactoryGirl.create(:master_data_account).id_soce).to eq(account1.id_soce+11)
        end
      end
    end
  end

  #info trads
 it "valid buque without special char"
 it "invalid buque with special char"
 it "valid buque zaloeil with special char"

  describe "add/remove alias" do
    account1 = FactoryGirl.create(:master_data_account)
    it "add new alias" do
      account1.add_new_alias("alias1")
      expect(account1.alias.first.name).to eq("alias1")
    end
    it "refuse to add existing alias for this account" do
      account1.add_new_alias("alias1")
      expect(account1.alias.count).to eq(1)
    end
  end
end
