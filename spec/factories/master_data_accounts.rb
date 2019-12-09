require "securerandom"
require "digest/sha1"

FactoryBot.define do
  factory :master_data_account, class: "MasterData::Account" do
    uuid { SecureRandom.uuid }
    hruid do
      "#{firstname.downcase}.#{lastname.downcase}.#{(1_900..2_000).to_a.sample}"
    end
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    is_gadz { true }
    # id_soce {(2000..20000).to_a.sample}
    enabled { true }
    password { Digest::SHA1.hexdigest uuid }
    email do
      Faker::Internet.safe_email(
        name: "#{firstname} #{lastname} " + rand(1..99).to_s,
      )
    end
    current_update_author { Faker::App.name.downcase }
  end
end
