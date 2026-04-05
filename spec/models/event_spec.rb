require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'associations' do
    it { should belong_to(:account) }
    it { should have_many(:guests).dependent(:destroy) }
    it { should have_many(:guest_categories).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
end
