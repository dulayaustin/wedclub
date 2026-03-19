class ApplicationController < ActionController::Base
  include AccountSessionable

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_account

  def after_sign_in_path_for(_resource)
    accounts_path
  end
end
