require 'rails_helper'

RSpec.describe HruidService, type: :service do

  firstname = "Roger"
  lastname = "Durant"
  proms = "2011"
  expected_hruid = "roger.durant.2011"
  expected_hruid_homonym2 = "roger.durant.2011.2"
  expected_hruid_homonym3 = "roger.durant.2011.3"

  it "generate Hruid with prom's for gadz" do
    account=FactoryGirl.build(:master_data_account, hruid: nil, firstname: firstname, lastname: lastname, gadz_proms_principale: proms)
    expect(HruidService::generate(account)).to eq(expected_hruid)
  end

  it "generate Hruid with number suffix for homonyms" do
    account1=FactoryGirl.create(:master_data_account, hruid: nil, firstname: firstname, lastname: lastname, gadz_proms_principale: proms, id_soce: nil, is_gadz: true)
    account2=FactoryGirl.create(:master_data_account, hruid: nil, firstname: firstname, lastname: lastname, gadz_proms_principale: proms, id_soce: nil, is_gadz: true)
    account3=FactoryGirl.build(:master_data_account, hruid: nil, firstname: firstname, lastname: lastname, gadz_proms_principale: proms)

    expect(account2.hruid).to eq(expected_hruid_homonym2)
    expect(HruidService::generate(account3)).to eq(expected_hruid_homonym3)

  end

  it "generate Hruid with soce for non gadz employee" do
    account_gadz=FactoryGirl.build(:master_data_account, hruid: nil, gadz_proms_principale: proms, is_soce_employee: true)
    account_pecks=FactoryGirl.build(:master_data_account, hruid: nil, gadz_proms_principale: nil, is_soce_employee: true)
    gadz_hruid_suffix = HruidService::generate(account_gadz).split(".").last
    pecks_hruid_suffix = HruidService::generate(account_pecks).split(".").last
    expect(gadz_hruid_suffix).to eq(proms)
    expect(pecks_hruid_suffix).to eq("soce")
  end

  it "generate Hruid with ext for ext" do
    account_ext=FactoryGirl.build(:master_data_account, hruid: nil, gadz_proms_principale: nil, is_soce_employee: false)
    ext_hruid_suffix = HruidService::generate(account_ext).split(".").last
    expect(ext_hruid_suffix).to eq("ext")
  end

end
