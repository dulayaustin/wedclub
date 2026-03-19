module AccountSessionable
  extend ActiveSupport::Concern

  def set_account_session(account)
    session[:account_id] = account.id
  end

  def clear_account_session
    session.delete(:account_id)
  end

  def current_account
    @current_account ||= Account.find_by(id: session[:account_id])
  end

  def require_account
    redirect_to accounts_path unless current_account
  end
end
