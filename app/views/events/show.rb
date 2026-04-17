# frozen_string_literal: true

class Views::Events::Show < Views::Base
  def initialize(event:)
    @event = event
  end

  def view_template
    render Views::Layouts::Sidebar::Event.new do
      div(class: "mb-6 flex items-center justify-between") do
        Heading(level: 1) { @event.title }
        Link(href: edit_event_path(@event), variant: :outline, size: :sm) { "Edit Details" }
      end

      div(class: "grid grid-cols-2 gap-4 mb-8") do
        div(class: "bg-card border border-border rounded-lg p-6") do
          Text(class: "text-sm text-muted-foreground") { "Total Guests" }
          div(class: "text-3xl font-bold mt-1") { @event.guests.count.to_s }
          Link(href: guests_path, variant: :ghost, size: :sm, class: "mt-2 px-0") { "View guests →" }
        end
        div(class: "bg-card border border-border rounded-lg p-6") do
          Text(class: "text-sm text-muted-foreground") { "Guest Categories" }
          div(class: "text-3xl font-bold mt-1") { @event.guest_categories.count.to_s }
          Link(href: guest_categories_path, variant: :ghost, size: :sm, class: "mt-2 px-0") { "View categories →" }
        end
      end

      div(class: "bg-card border border-border rounded-lg p-6") do
        Heading(level: 2, class: "mb-4") { "Event Details" }
        if @event.event_date.present? || @event.venue.present? || @event.theme.present?
          div(class: "divide-y divide-border") do
            if @event.event_date.present?
              div(class: "flex justify-between items-center py-3") do
                Text(class: "text-sm text-muted-foreground") { "Date" }
                Text(class: "text-sm font-medium") { @event.event_date.strftime("%B %-d, %Y") }
              end
            end
            if @event.venue.present?
              div(class: "flex justify-between items-center py-3") do
                Text(class: "text-sm text-muted-foreground") { "Venue" }
                Text(class: "text-sm font-medium") { @event.venue }
              end
            end
            if @event.theme.present?
              div(class: "flex justify-between items-center py-3") do
                Text(class: "text-sm text-muted-foreground") { "Theme" }
                Text(class: "text-sm font-medium") { @event.theme }
              end
            end
          end
        else
          Text(class: "text-sm text-muted-foreground") { "No details set yet. " }
          Link(href: edit_event_path(@event), variant: :ghost, size: :sm, class: "px-0") { "Add details →" }
        end
      end
    end
  end
end
