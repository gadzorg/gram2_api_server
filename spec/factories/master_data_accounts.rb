require 'securerandom'
require 'digest/sha1'

FactoryGirl.define do
  factory :master_data_account, class: 'MasterData::Account' do
      uuid {SecureRandom.uuid}
      hruid {"#{firstname}.#{lastname}.#{(1900..2000).to_a.sample}"}
      firstname {Faker::Name.first_name}
      lastname {Faker::Name.last_name}
      is_gadz true
      # id_soce {(2000..20000).to_a.sample}
      enabled true
      password {Digest::SHA1.hexdigest uuid}
      email {Faker::Internet.safe_email("#{firstname} #{lastname} "+rand(1..99).to_s)}
  end
end