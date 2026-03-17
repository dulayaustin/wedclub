require 'rails_helper'

RSpec.describe AccountGuestCategory, type: :model do
  describe 'associations' do
    it { should belong_to(:account) }
    it { should have_many(:guest_categories) }
    it { should have_many(:guests) }
  end

  describe 'validations' do
    subject { build(:account_guest_category) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:account_id) }
  end
end
