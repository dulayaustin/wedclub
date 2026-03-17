class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  def current_account
    @current_account ||= Account.find_by(id: session[:account_id])
  end
  helper_method :current_account

  def require_account
    redirect_to accounts_path unless current_account
  end
end
