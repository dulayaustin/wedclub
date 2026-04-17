# frozen_string_literal: true

class Views::Users::Sessions::New < Views::Base
  def initialize(user:)
    @user = user
  end

  def view_template
    div(class: "min-h-screen flex items-center justify-center bg-background px-4") do
      div(class: "w-full max-w-md") do
        div(class: "mb-8 text-center") do
          a(href: root_path, class: "inline-flex items-center gap-2 text-foreground no-underline justify-center mb-4") do
            div(class: "h-10 w-10 rounded-full bg-primary flex items-center justify-center text-primary-foreground font-bold") { "W" }
            span(class: "font-semibold text-lg") { "WedClub" }
          end
          Heading(level: 1, class: "text-2xl") { "Welcome back" }
          Text(class: "text-muted-foreground mt-1") { "Sign in to your account" }
        end

        div(class: "bg-card border border-border rounded-lg shadow-sm p-8") do
          render_flash
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
  end
end
