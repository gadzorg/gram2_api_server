require 'rails_helper'

RSpec.describe HruidService, type: :service do

  firstname = "Roger"
  lastname = "Durant"
  proms = "2011"
  expected_hruid = "roger.durant.2011"
  expected_hruid_homonym2 = "roger.durant.2011.2"
  expected_hruid_homonym3 = "roger.durant.2011.3"

  it "generate Hruid with prom's for gadz" do
    account= build(:master_data_account, hruid: nil, firstname: firstname, lastname: lastname, gadz_proms_principale: proms)
    expect(HruidService::generate(account)).to eq(expected_hruid)
  end

  it "generate Hruid with number suffix for homonyms" do
    account1= create(:master_data_account, hruid: nil, firstname: firstname, lastname: lastname, gadz_proms_principale: proms, id_soce: nil, is_gadz: true)
    account2= create(:master_data_account, hruid: nil, firstname: firstname, lastname: lastname, gadz_proms_principale: proms, id_soce: nil, is_gadz: true)
    account3= build(:master_data_account, hruid: nil, firstname: firstname, lastname: lastname, gadz_proms_principale: proms)

    expect(account2.hruid).to eq(expected_hruid_homonym2)
    expect(HruidService::generate(account3)).to eq(expected_hruid_homonym3)
  end

  it "generate Hruid with soce for non gadz employee" do
    account_pecks= build(:master_data_account, hruid: nil, gadz_proms_principale: nil, is_soce_employee: true)
    pecks_hruid_suffix = HruidService::generate(account_pecks).split(".").last
    expect(pecks_hruid_suffix).to eq("soce")
  end

  it "generate Hruid with promo for gadz employee" do
    account_gadz= build(:master_data_account, hruid: nil, gadz_proms_principale: proms, is_soce_employee: true)
    gadz_hruid_suffix = HruidService::generate(account_gadz).split(".").last
    expect(gadz_hruid_suffix).to eq(proms)
  end

  it "generate Hruid with ext for ext" do
    account_ext= build(:master_data_account, hruid: nil, gadz_proms_principale: nil, is_soce_employee: false)
    ext_hruid_suffix = HruidService::generate(account_ext).split(".").last
    expect(ext_hruid_suffix).to eq("ext")
  end

end
