# frozen_string_literal: true

class Views::EventVenues::Edit < Views::Base
  def initialize(event_venue:, venues:, available_roles:)
    @event_venue = event_venue
    @venues = venues
    @available_roles = available_roles
  end

  def view_template
    render Views::Layouts::Sidebar::Event.new do
      div(class: "flex items-center justify-between gap-4 mb-6") do
        Heading(level: 1) { "Edit Venue Assignment" }
      end

      render Views::EventVenues::Form.new(event_venue: @event_venue, venues: @venues, available_roles: @available_roles)
    end
  end
end
