FactoryBot.define do
  factory :car do
    model { Faker::Vehicle.manufacture }
    make { Faker::Vehicle.model }
    year { Faker::Vehicle.year }
    mileage { Faker::Vehicle.mileage }
  end
end