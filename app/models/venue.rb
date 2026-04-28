# == Schema Information
#
# Table name: venues
#
#  id            :bigint           not null, primary key
#  address_line1 :text
#  address_line2 :text
#  city          :string
#  country       :string
#  name          :string           not null
#  notes         :text
#  phone_number  :string
#  state         :string
#  venue_type    :integer          not null
#  website       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_venues_on_name  (name)
#

class Venue < ApplicationRecord
  enum :venue_type, { church: 0, garden: 1, beach: 2, hall: 3, hotel: 4 }, prefix: true

  has_many :event_venues, dependent: :destroy

  validates :name, presence: true
  validates :venue_type, presence: true
end
