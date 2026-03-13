require 'rails_helper'

RSpec.describe GuestCategory, type: :model do
  describe 'validations' do
    subject { build(:guest_category) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
