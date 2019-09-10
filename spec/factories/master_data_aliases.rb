FactoryBot.define do
  factory :master_data_alias, class: "MasterData::Alias" do
    name { Faker::Team.creature }
  end
end
