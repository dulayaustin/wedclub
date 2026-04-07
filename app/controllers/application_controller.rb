class ApplicationController < ActionController::Base
  include AccountSessionable

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_account, :current_event

  def after_sign_in_path_for(_resource)
    if current_account&.events&.any?
      event = current_account.events.first
      set_event_session(event)
      event_path(event)
    else
      accounts_path
    end
  end
end
