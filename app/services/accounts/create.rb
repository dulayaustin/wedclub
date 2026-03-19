module Accounts
  class Create
    Result = Data.define(:success, :account) do
      def success? = success
    end

    def initialize(user:, params:)
      @user   = user
      @params = params
    end

    def call
      account = Account.new(@params)
      if account.save
        account.account_users.create!(user: @user)
        Result.new(success: true, account: account)
      else
        Result.new(success: false, account: account)
      end
    end
  end
end
