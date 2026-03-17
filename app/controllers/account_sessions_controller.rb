class AccountSessionsController < ApplicationController
  def create
    account = Account.find(params[:account_id])
    session[:account_id] = account.id
    redirect_to guests_path
  end

  def destroy
    session.delete(:account_id)
    redirect_to accounts_path
  end
end
