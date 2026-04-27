class Venue < ApplicationRecord
  enum :venue_type, { church: 0, garden: 1, beach: 2, hall: 3, hotel: 4 }, prefix: true

  validates :name, presence: true
  validates :venue_type, presence: true
end
