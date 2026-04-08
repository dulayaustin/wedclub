# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [ :create ]

  def new
    self.resource = resource_class.new
    render Views::Users::Registrations::New.new(
      user: self.resource, account: Account.new, event: Event.new
    )
  end

  def create
    result = Registrations::Create.new(
      user_params:         sign_up_params,
      account_params:      account_params,
      event_params:        event_params,
      account_user_params: account_user_params
    ).call

    if result.success?
      self.resource = result.user
      sign_up(resource_name, result.user)
      set_account_session(result.account)
      set_event_session(result.event)
      redirect_to event_path(result.event), notice: "Welcome! Your event is ready."
    else
      self.resource = result.user
      render Views::Users::Registrations::New.new(
        user: result.user, account: result.account, event: result.event, account_user: result.account_user
      ), status: :unprocessable_entity
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :first_name, :last_name ])
  end

  private

  def account_params
    { name: params.dig(:event, :title) }
  end

  def event_params
    params.require(:event).permit(:title, :event_date)
  end

  def account_user_params
    params.require(:account_user).permit(:role)
  end
end
