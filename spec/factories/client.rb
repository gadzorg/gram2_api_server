FactoryBot.define do
  factory :client, class: "Client" do
    name { Faker::App.name.downcase }
    password { Digest::SHA1.hexdigest name }
    authentication_token { nil }
    active { true }
    email do
      Faker::Internet.safe_email(
        name:
          "#{Faker::Name.first_name} #{Faker::Name.last_name} " +
            rand(1..99).to_s,
      )
    end
  end

  trait :api_client do
    name { "client" }
    authentication_token { "secrettoken" }

    after :create do |client|
      client.add_role :gram_admin
      client.add_role :admin
    end
  end
end
