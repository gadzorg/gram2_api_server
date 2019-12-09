require "rails_helper"

RSpec.describe MasterData::Role, type: :model do
  it "has a valid factory" do
    expect(build(:master_data_role)).to be_valid
  end

  it "has an empty database" do
    expect(MasterData::Role.count).to eq(0)
  end

  it "validate presence of a uuid"
  it "contain name"
  it "contain application"
  it "contain description"
end
