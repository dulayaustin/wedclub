FactoryBot.define do
  factory :venue do
    name       { Faker::Company.name }
    venue_type { Venue.venue_types.keys.sample }
    city       { Faker::Address.city }
    country    { Faker::Address.country }
  end
end
