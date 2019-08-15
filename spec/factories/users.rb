FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { Faker::Crypto.md5 }
    password_confirmation { password }
    street { Faker::Address.street_address }
    city { Faker::Address.city }
    postal_code { Faker::Address.postcode }
    phone_number { Faker::PhoneNumber.phone_number_with_country_code }
      factory :owner do
        role 'owner'
      end
      factory :customer do
        role 'customer'
      end
  end
end