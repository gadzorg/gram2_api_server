FactoryBot.define do
  factory :master_data_role, class: "MasterData::Role" do
    uuid { SecureRandom.uuid }
    application { Faker::Company.name }
    name { Faker::Team.creature + Faker::Name.first_name }
    description { Faker::Company.catch_phrase }
  end
end
