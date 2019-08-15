FactoryBot.define do
  factory :office do
    street { Faker::Address.street_address }
    postal_code { Faker::Address.postcode }
    city { Faker::Address.city }
    phone_number { Faker::PhoneNumber.phone_number_with_country_code }
  end
end