require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'associations' do
    it { should have_many(:account_guest_categories).dependent(:destroy) }
    it { should have_many(:guests).through(:account_guest_categories) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
end
