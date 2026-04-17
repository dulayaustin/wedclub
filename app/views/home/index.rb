# frozen_string_literal: true

class Views::Home::Index < Views::Base
  def initialize(account:)
    @account = account
  end

  def view_template
    render Views::Layouts::Sidebar::Account.new do
      Heading(level: 1, class: "mb-1") { "Welcome, #{current_user&.first_name}!" }
      Text(class: "text-muted-foreground mb-6") { current_account&.name || "Select an account to get started." }
      Separator(class: "mb-6")

      if current_account
        upcoming = current_account.events.select { |e| e.event_date&.future? }.min_by(&:event_date)

        if upcoming
          div(class: "bg-card border border-border rounded-lg p-6 mb-6") do
            div(class: "flex items-center justify-between") do
              div do
                Text(class: "text-xs text-muted-foreground uppercase tracking-wider mb-1") { "Next Event" }
                Heading(level: 2, class: "mb-1") { upcoming.title }
                Text(class: "text-muted-foreground text-sm") { upcoming.event_date.strftime("%B %-d, %Y") }
              end
              Link(href: event_path(upcoming), variant: :outline, size: :sm) { "Open Event" }
            end
          end
        end

        div(class: "grid grid-cols-3 gap-4 mb-6") do
          div(class: "bg-card border border-border rounded-lg p-5 text-center") do
            div(class: "text-2xl font-bold") { current_account.events.size.to_s }
            Text(class: "text-sm text-muted-foreground mt-1") { "Events" }
          end
          if current_event
            div(class: "bg-card border border-border rounded-lg p-5 text-center") do
              div(class: "text-2xl font-bold") { current_event.guests.count.to_s }
              Text(class: "text-sm text-muted-foreground mt-1") { "Guests" }
            end
            div(class: "bg-card border border-border rounded-lg p-5 text-center") do
              div(class: "text-2xl font-bold") { current_event.guest_categories.count.to_s }
              Text(class: "text-sm text-muted-foreground mt-1") { "Categories" }
            end
          end
        end

        Separator(class: "mb-6")

        div(class: "space-y-4") do
          Heading(level: 2) { "Quick Actions" }
          div(class: "flex gap-3") do
            Link(href: events_path, variant: :outline) { "View Events" }
            Link(href: new_account_path, variant: :outline) { "New Account" }
          end
        end
      else
        div(class: "space-y-4") do
          Text { "You don't have any accounts yet." }
          Link(href: new_account_path, variant: :primary) { "Create your first account" }
        end
      end
    end
  end
end
