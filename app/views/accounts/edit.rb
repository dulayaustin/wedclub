# frozen_string_literal: true

class Views::Accounts::Edit < Views::Base
  def initialize(account:)
    @account = account
  end

  def view_template
    render Views::Layouts::Sidebar::Account.new do
      div(class: "max-w-md") do
        div(class: "mb-6 flex items-center gap-4") do
          Link(href: accounts_path, variant: :ghost, size: :sm) { "← Back" }
          Heading(level: 1) { "Edit Account" }
        end

        Form(action: account_path(@account), method: :post, class: "space-y-4") do
          input(type: :hidden, name: "authenticity_token", value: form_authenticity_token, autocomplete: "off")
          input(type: :hidden, name: "_method", value: "patch")

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

          Button(type: :submit, variant: :primary, class: "w-full") { "Update Account" }
        end
      end
    end
  end
end
