FactoryBot.define do
  factory :event do
    association :account

    name { Faker::Lorem.unique.word }
    event_date { Faker::Date.between(from: 1.year.ago, to: 1.year.from_now) }
  end
end
