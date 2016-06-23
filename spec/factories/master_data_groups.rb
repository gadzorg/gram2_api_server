FactoryGirl.define do
  factory :master_data_group, class: 'MasterData::Group' do
    guid "MyString"
    name Faker::Team.creature
    short_name Faker::Team.creature.downcase
    description "MyString"
  end
end