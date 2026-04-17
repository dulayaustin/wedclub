# frozen_string_literal: true

class Views::Accounts::Show < Views::Base
  def initialize(account:)
    @account = account
  end

  def view_template
    render Views::Layouts::Sidebar::Account.new do
      div(class: "mb-6 flex items-center gap-4") do
        Link(href: accounts_path, variant: :ghost, size: :sm) { "← Back" }
        Heading(level: 1) { @account.name }
      end

      div(class: "flex gap-2") do
        Link(href: edit_account_path(@account), variant: :primary, size: :sm) { "Edit" }
        Form(action: account_path(@account), method: :post) do
          input(type: :hidden, name: "authenticity_token", value: form_authenticity_token, autocomplete: "off")
          input(type: :hidden, name: "_method", value: "delete")
          Button(type: :submit, variant: :ghost, size: :sm) { "Delete" }
        end
      end
    end
  end
end
