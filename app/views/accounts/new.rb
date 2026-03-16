# frozen_string_literal: true

class Views::Accounts::New < Views::Base
  def initialize(account:)
    @account = account
  end

  def view_template
    div(class: "container mx-auto py-10 px-4 max-w-md") do
      div(class: "mb-6 flex items-center gap-4") do
        Link(href: accounts_path, variant: :ghost, size: :sm) { "← Back" }
        Heading(level: 1) { "New Account" }
      end

      form(action: accounts_path, method: :post, class: "space-y-4") do
        input(type: :hidden, name: "authenticity_token", value: form_authenticity_token, autocomplete: "off")

        FormField do
          FormFieldLabel(for: "account_name") { "Name" }
          Input(
            id: "account_name",
            type: :text,
            name: "account[name]",
            value: @account.name.to_s,
            placeholder: "Enter account name",
            required: true
          )
          FormFieldError { @account.errors[:name].first } if @account.errors[:name].any?
        end

        Button(type: :submit, variant: :primary, class: "w-full") { "Create Account" }
      end
    end
  end
end
