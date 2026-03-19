require 'rails_helper'

RSpec.describe Accounts::Create do
  let(:user) { create(:user) }

  describe '#call' do
    context 'with valid params' do
      let(:params) { { name: 'Smith Wedding' } }

      it 'returns a successful result' do
        result = described_class.new(user: user, params: params).call
        expect(result).to be_success
      end

      it 'creates an account' do
        expect {
          described_class.new(user: user, params: params).call
        }.to change(Account, :count).by(1)
      end

      it 'returns the created account' do
        result = described_class.new(user: user, params: params).call
        expect(result.account).to be_a(Account)
        expect(result.account.name).to eq('Smith Wedding')
      end

      it 'associates the user with the account' do
        result = described_class.new(user: user, params: params).call
        expect(result.account.users).to include(user)
      end

      it 'creates an account_user record' do
        expect {
          described_class.new(user: user, params: params).call
        }.to change(AccountUser, :count).by(1)
      end
    end

    context 'with invalid params' do
      let(:params) { { name: '' } }

      it 'returns a failed result' do
        result = described_class.new(user: user, params: params).call
        expect(result).not_to be_success
      end

      it 'does not create an account' do
        expect {
          described_class.new(user: user, params: params).call
        }.not_to change(Account, :count)
      end

      it 'does not create an account_user record' do
        expect {
          described_class.new(user: user, params: params).call
        }.not_to change(AccountUser, :count)
      end

      it 'returns the invalid account' do
        result = described_class.new(user: user, params: params).call
        expect(result.account).to be_a(Account)
        expect(result.account).not_to be_persisted
      end
    end
  end
end
