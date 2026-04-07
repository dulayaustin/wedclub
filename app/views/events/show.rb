# frozen_string_literal: true

class Views::Events::Show < Views::Base
  def initialize(event:)
    @event = event
  end

  def view_template
    div(class: "container mx-auto py-10 px-4 max-w-2xl") do
      div(class: "mb-6 flex items-center justify-between") do
        Heading(level: 1) { @event.name }
        Link(href: edit_event_path(@event), variant: :outline, size: :sm) { "Edit Details" }
      end

      div(class: "space-y-2 mb-8") do
        if @event.event_date.present?
          p { "Date: #{@event.event_date.strftime("%B %-d, %Y")}" }
        end
        if @event.venue.present?
          p { "Venue: #{@event.venue}" }
        end
        if @event.theme.present?
          p { "Theme: #{@event.theme}" }
        end
      end

      div(class: "flex gap-4") do
        Link(href: guests_path, variant: :primary) { "Manage Guests" }
        Link(href: guest_categories_path, variant: :outline) { "Guest Categories" }
      end
    end
  end
end
