# frozen_string_literal: true

class Views::Users::Registrations::New < Views::Base
  def initialize(user:, account:, event:)
    @user = user
    @account = account
    @event = event
  end

  def view_template
    div(class: "container mx-auto py-10 px-4 max-w-md") do
      div(class: "mb-6 flex items-center gap-4") do
        Link(href: root_path, variant: :ghost, size: :sm) { "← Back" }
        Heading(level: 1) { "Sign Up" }
      end

      form(action: user_registration_path, method: :post, class: "space-y-6") do
        input(type: :hidden, name: "authenticity_token", value: form_authenticity_token, autocomplete: "off")

        Heading(level: 2) { "Your Profile" }

        FormField do
          FormFieldLabel(for: "user_first_name") { "First Name" }
          Input(id: "user_first_name", type: :text, name: "user[first_name]", value: @user.first_name.to_s, required: true)
          FormFieldError { @user.errors[:first_name].first } if @user.errors[:first_name].any?
        end

        FormField do
          FormFieldLabel(for: "user_last_name") { "Last Name" }
          Input(id: "user_last_name", type: :text, name: "user[last_name]", value: @user.last_name.to_s, required: true)
          FormFieldError { @user.errors[:last_name].first } if @user.errors[:last_name].any?
        end

        FormField do
          FormFieldLabel(for: "user_email") { "Email" }
          Input(id: "user_email", type: :email, name: "user[email]", value: @user.email.to_s, required: true)
          FormFieldError { @user.errors[:email].first } if @user.errors[:email].any?
        end

        FormField do
          FormFieldLabel(for: "user_password") { "Password" }
          Input(id: "user_password", type: :password, name: "user[password]", required: true)
          FormFieldError { @user.errors[:password].first } if @user.errors[:password].any?
        end

        FormField do
          FormFieldLabel(for: "user_password_confirmation") { "Password Confirmation" }
          Input(id: "user_password_confirmation", type: :password, name: "user[password_confirmation]", required: true)
          FormFieldError { @user.errors[:password_confirmation].first } if @user.errors[:password_confirmation].any?
        end

        Heading(level: 2) { "Your Event" }

        FormField do
          FormFieldLabel(for: "event_name") { "Event Name" }
          Input(id: "event_name", type: :text, name: "event[name]", value: @event.name.to_s, placeholder: "Smith & Jones Wedding", required: true)
          FormFieldError { @event.errors[:name].first } if @event.errors[:name].any?
          FormFieldError { @account.errors[:name].first } if @account.errors[:name].any?
        end

        FormField do
          FormFieldLabel(for: "event_event_date") { "Event Date (optional)" }
          Input(id: "event_event_date", type: :date, name: "event[event_date]", value: @event.event_date&.to_date&.to_s)
          FormFieldError { @event.errors[:event_date].first } if @event.errors[:event_date].any?
        end

        Button(type: :submit, variant: :primary, class: "w-full") { "Sign Up" }
      end

      div(class: "mt-4 text-center text-sm") do
        plain "Already have an account? "
        Link(href: new_user_session_path, variant: :ghost, size: :sm) { "Sign In" }
      end
    end
  end
end
