require 'rails_helper'

RSpec.describe Venue, type: :model do
  describe 'enums' do
    it { should define_enum_for(:venue_type).with_values({ church: 0, garden: 1, beach: 2, hall: 3, hotel: 4 }).with_prefix }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:venue_type) }
  end
end
