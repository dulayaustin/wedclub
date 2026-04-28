FactoryBot.define do
  factory :event_venue do
    association :event
    association :venue
    role { EventVenue.roles.keys.first }
  end
end
