FactoryBot.define do
  factory :master_data_alias, class: "MasterData::Alias" do
    association :account, factory: :master_data_account
    name { Faker::Team.creature }
  end
end
