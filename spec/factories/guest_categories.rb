FactoryBot.define do
  factory :guest_category do
    association :event

    name { Faker::Lorem.unique.word }
  end
end
