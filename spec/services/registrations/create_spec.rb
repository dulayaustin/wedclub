require 'rails_helper'

RSpec.describe Registrations::Create do
  let(:valid_user_params)    { { first_name: "Jane", last_name: "Smith", email: "jane@example.com", password: "password123", password_confirmation: "password123" } }
  let(:valid_account_params) { { name: "Smith Wedding" } }
  let(:valid_event_params)   { { name: "Smith Wedding", event_date: 1.year.from_now } }

  def call(user_params: valid_user_params, account_params: valid_account_params, event_params: valid_event_params)
    described_class.new(user_params: user_params, account_params: account_params, event_params: event_params).call
  end

  describe '#call' do
    context 'with valid params' do
      it 'returns a successful result' do
        expect(call).to be_success
      end

      it 'creates a user, account, and event atomically' do
        expect { call }.to change(User, :count).by(1)
          .and change(Account, :count).by(1)
          .and change(Event, :count).by(1)
          .and change(AccountUser, :count).by(1)
      end

      it 'returns the created records' do
        result = call
        expect(result.user).to be_a(User).and be_persisted
        expect(result.account).to be_a(Account).and be_persisted
        expect(result.event).to be_a(Event).and be_persisted
      end

      it 'scopes the event to the account' do
        result = call
        expect(result.event.account).to eq(result.account)
      end
    end

    context 'with invalid user params' do
      let(:bad_user_params) { valid_user_params.merge(email: '') }

      it 'returns a failed result' do
        expect(call(user_params: bad_user_params)).not_to be_success
      end

      it 'rolls back all records' do
        expect { call(user_params: bad_user_params) }.not_to change(User, :count)
        expect { call(user_params: bad_user_params) }.not_to change(Account, :count)
        expect { call(user_params: bad_user_params) }.not_to change(Event, :count)
      end

      it 'returns the invalid user with errors' do
        result = call(user_params: bad_user_params)
        expect(result.user.errors[:email]).not_to be_empty
      end
    end

    context 'with invalid account params' do
      let(:bad_account_params) { { name: '' } }

      it 'returns a failed result' do
        expect(call(account_params: bad_account_params)).not_to be_success
      end

      it 'rolls back all records' do
        expect { call(account_params: bad_account_params) }.not_to change(User, :count)
        expect { call(account_params: bad_account_params) }.not_to change(Account, :count)
        expect { call(account_params: bad_account_params) }.not_to change(Event, :count)
      end
    end

    context 'with invalid event params' do
      let(:bad_event_params) { { name: '' } }

      it 'returns a failed result' do
        expect(call(event_params: bad_event_params)).not_to be_success
      end

      it 'rolls back all records' do
        expect { call(event_params: bad_event_params) }.not_to change(User, :count)
        expect { call(event_params: bad_event_params) }.not_to change(Account, :count)
        expect { call(event_params: bad_event_params) }.not_to change(Event, :count)
      end
    end
  end
end
