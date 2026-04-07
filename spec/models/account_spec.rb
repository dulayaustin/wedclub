require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'associations' do
    it { should have_many(:account_users).dependent(:destroy) }
    it { should have_many(:users).through(:account_users) }
    it { should have_many(:events).dependent(:destroy) }
    it { should have_many(:guests).through(:events) }
    it { should have_many(:guest_categories).through(:events) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
end
