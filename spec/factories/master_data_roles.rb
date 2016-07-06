FactoryGirl.define do
  factory :master_data_role, class: 'MasterData::Role' do
    uuid {SecureRandom.uuid}
    application "MyString"
    name "MyString"
    description "MyString"
  end
end
