class AccountSessionsController < ApplicationController
  def create
    account = current_user.accounts.find(params[:account_id])
    set_account_session(account)
    clear_event_session
    if account.events.any?
      event = account.events.first
      set_event_session(event)
      redirect_to event_path(event)
    else
      redirect_to accounts_path
    end
  end

  def destroy
    clear_account_session
    clear_event_session
    redirect_to accounts_path
  end
end
