require 'securerandom'
require 'digest/sha1'

FactoryGirl.define do
  factory :master_data_account, class: 'MasterData::Account' do
      uuid {SecureRandom.uuid}
      hruid {"#{Faker::Name.first_name}.#{Faker::Name.last_name}.#{(1900..2000).to_a.sample}"}
      id_soce {(2000..20000).to_a.sample}
      enabled true
      password {Digest::SHA1.hexdigest uuid}
      email {Faker::Internet.safe_email("#{Faker::Name.first_name} #{Faker::Name.last_name} "+rand(1..99).to_s)}
  end
end