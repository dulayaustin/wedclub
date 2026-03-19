class AccountSessionsController < ApplicationController
  def create
    account = Account.find(params[:account_id])
    set_account_session(account)
    redirect_to guests_path
  end

  def destroy
    clear_account_session
    redirect_to accounts_path
  end
end
