require "rails_helper"

RSpec.describe MasterData::Alias, type: :model do
  it "has a valid factory" do
    expect(build(:master_data_alias)).to be_valid
  end

  it "has an empty database" do
    expect(MasterData::Alias.count).to eq(0)
  end

  it "invalidate duplicates names" do
    alias1 = create(:master_data_alias, name: "test_alias1")
    alias2 = build(:master_data_alias, name: "test_alias1")
    expect(alias2.valid?).to eq(false)
  end

  it "invalidate duplicates names with deffent case" do
    alias1 = create(:master_data_alias, name: "test_alias2")
    alias2 = build(:master_data_alias, name: "TEST_alias2")
    expect(alias2.valid?).to eq(false)
  end
end
