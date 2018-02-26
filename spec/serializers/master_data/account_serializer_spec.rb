require 'rails_helper'

RSpec.describe MasterData::AccountSerializer, :type => :serializer do
  before(:each) do
    @account = FactoryGirl.build(:master_data_account)
    serializer = MasterData::AccountSerializer.new(@account)
    @serialization = ActiveModelSerializers::Adapter.create(serializer)
  end

  subject { JSON.parse(@serialization.to_json) }

  describe "attributes" do
    it "should include proms and centre" do
      @account.attributes = {
        gadz_proms_principale: "2017",
        gadz_centre_principal: "ch"
      }
      
      expect(subject["gadz_proms_principale"]).to eq("2017")
      expect(subject["gadz_centre_principal"]).to eq("ch")
    end
  end
end