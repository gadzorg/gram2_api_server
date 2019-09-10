require "rails_helper"

RSpec.describe MasterData::Group, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  it "has a valid factory" do
    expect(build(:master_data_group)).to be_valid
  end

  it "has an empty database" do
    expect(MasterData::Group.count).to eq(0)
  end

  it "validate presence of a uuid"
  it "contain name"
  it "contain short_name"
end
