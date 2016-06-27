FactoryGirl.define do
  factory :client, class: 'Client' do
    name Faker::Team.creature
    password {Digest::SHA1.hexdigest name}
    email {Faker::Internet.safe_email("#{Faker::Name.first_name} #{Faker::Name.last_name} "+rand(1..99).to_s)}
  end
end