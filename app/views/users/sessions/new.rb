# frozen_string_literal: true

class Views::Users::Sessions::New < Views::Base
  def initialize(user:)
    @user = user
  end

  def view_template
    div(class: "container mx-auto py-10 px-4 max-w-md") do
      div(class: "mb-6 flex items-center gap-4") do
        Heading(level: 1) { "Sign In" }
      end

      Form(action: user_session_path, method: :post, class: "space-y-4") do
        input(type: :hidden, name: "authenticity_token", value: form_authenticity_token, autocomplete: "off")

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
          div(class: "flex items-center gap-2") do
            Checkbox(id: "user_remember_me", name: "user[remember_me]", value: "1")
            FormFieldLabel(for: "user_remember_me") { "Remember me" }
          end
        end

        Button(type: :submit, variant: :primary, class: "w-full") { "Sign In" }
      end

      div(class: "mt-4 text-center text-sm space-y-2") do
        p do
          plain "Don't have an account? "
          Link(href: new_user_registration_path, variant: :ghost, size: :sm) { "Sign Up" }
        end
        p do
          Link(href: new_user_password_path, variant: :ghost, size: :sm) { "Forgot your password?" }
        end
      end
    end
  end
end
