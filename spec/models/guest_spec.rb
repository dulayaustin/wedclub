require 'rails_helper'

RSpec.describe Guest, type: :model do
  describe 'associations' do
    it { should have_one(:guest_category).dependent(:destroy) }
    it { should have_one(:account_guest_category).through(:guest_category) }
  end

  describe 'enums' do
    it { should define_enum_for(:age_group).with_values({ adult: 0, child: 1 }).with_prefix }
    it { should define_enum_for(:guest_of).with_values({ bride: 0, groom: 1, both: 2 }).with_prefix }
  end

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
  end
end
