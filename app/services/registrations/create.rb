# frozen_string_literal: true

module Registrations
  class Create
    Result = Data.define(:success, :user, :account, :event, :account_user) do
      def success? = success
    end

    def initialize(user_params:, account_params:, event_params:, account_user_params: {})
      @user_params         = user_params
      @account_params      = account_params
      @event_params        = event_params
      @account_user_params = account_user_params
      @built_user         = User.new
      @built_account      = Account.new
      @built_event        = Event.new
      @built_account_user = AccountUser.new
    end

    def call
      ActiveRecord::Base.transaction do
        @built_user = User.new(@user_params)
        raise ActiveRecord::Rollback unless @built_user.save

        @built_account = Account.new(@account_params)
        raise ActiveRecord::Rollback unless @built_account.save

        @built_account_user = @built_account.account_users.new(@account_user_params.merge(user: @built_user))
        raise ActiveRecord::Rollback unless @built_account_user.save

        @built_event = @built_account.events.new(@event_params)
        raise ActiveRecord::Rollback unless @built_event.save

        return Result.new(success: true, user: @built_user, account: @built_account, event: @built_event, account_user: @built_account_user)
      end

      Result.new(success: false, user: @built_user, account: @built_account, event: @built_event, account_user: @built_account_user)
    end
  end
end
