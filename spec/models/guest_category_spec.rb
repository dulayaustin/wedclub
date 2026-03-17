RSpec.describe GuestCategory, type: :model do
  describe 'associations' do
    it { should belong_to(:guest) }
    it { should belong_to(:account_guest_category) }
  end
end
