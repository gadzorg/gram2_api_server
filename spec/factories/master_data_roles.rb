FactoryBot.define do
  factory :master_data_role, class: "MasterData::Role" do
    uuid { SecureRandom.uuid }
    application "MyString"
    name { Faker::Team.creature + Faker::Name.first_name }
    description "MyString"
  end
end
