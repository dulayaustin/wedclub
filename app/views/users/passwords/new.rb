# frozen_string_literal: true

class Views::Users::Passwords::New < Views::Base
  def initialize(user:)
    @user = user
  end

  def view_template
    div(class: "container mx-auto py-10 px-4 max-w-md") do
      div(class: "mb-6 flex items-center gap-4") do
        Link(href: new_user_session_path, variant: :ghost, size: :sm) { "← Back" }
        Heading(level: 1) { "Forgot Password" }
      end

      render_flash
      Form(action: user_password_path, method: :post, class: "space-y-4") do
        input(type: :hidden, name: "authenticity_token", value: form_authenticity_token, autocomplete: "off")

        FormField do
          FormFieldLabel(for: "user_email") { "Email" }
          Input(id: "user_email", type: :email, name: "user[email]", value: @user.email.to_s, required: true)
          FormFieldError { @user.errors[:email].first } if @user.errors[:email].any?
        end

        Button(type: :submit, variant: :primary, class: "w-full") { "Send Reset Instructions" }
      end

      div(class: "mt-4 text-center text-sm") do
        Link(href: new_user_session_path, variant: :ghost, size: :sm) { "Back to Sign In" }
      end
    end
  end
end
