# frozen_string_literal: true

class Views::Accounts::Index < Views::Base
  def initialize(accounts:)
    @accounts = accounts
  end

  def view_template
    render Views::Layouts::Sidebar::Account.new do
      div(class: "flex items-center justify-between mb-6") do
        Heading(level: 1) { "Accounts" }
        Link(href: new_account_path, variant: :primary) { "New Account" }
      end

      Table do
        TableHeader do
          TableRow do
            TableHead { "Name" }
            TableHead { "Created" }
            TableHead { "Actions" }
          end
        end
        TableBody do
          if @accounts.any?
            @accounts.each do |account|
              active = current_account&.id == account.id
              TableRow(class: active ? "bg-muted/50" : nil) do
                TableCell do
                  div(class: "flex items-center gap-2") do
                    plain account.name
                    Badge(variant: :outline) { "Selected" } if active
                  end
                end
                TableCell { account.created_at.strftime("%b %d, %Y") }
                TableCell do
                  div(class: "flex items-center gap-2") do
                    unless active
                      form(action: account_session_path, method: :post) do
                        input(type: :hidden, name: "authenticity_token", value: form_authenticity_token, autocomplete: "off")
                        input(type: :hidden, name: "account_id", value: account.id)
                        Button(type: :submit, variant: :outline, size: :sm) { "Select" }
                      end
                    end
                    Link(href: edit_account_path(account), variant: :ghost, size: :sm) { "Edit" }
                    form(action: account_path(account), method: :post) do
                      input(type: :hidden, name: "authenticity_token", value: form_authenticity_token, autocomplete: "off")
                      input(type: :hidden, name: "_method", value: "delete")
                      Button(type: :submit, variant: :ghost, size: :sm) { "Delete" }
                    end
                  end
                end
              end
            end
          else
            TableRow do
              TableCell(class: "text-center text-muted-foreground py-8", colspan: "3") do
                "No accounts yet."
              end
            end
          end
        end
      end
    end
  end
end
