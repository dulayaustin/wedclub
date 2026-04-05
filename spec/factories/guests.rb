FactoryBot.define do
  factory :guest do
    association :event
    association :guest_category, optional: true

    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end
end
