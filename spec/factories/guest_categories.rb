FactoryBot.define do
  factory :guest_category do
    name { Faker::Lorem.unique.word }
  end
end
