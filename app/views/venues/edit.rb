# frozen_string_literal: true

class Views::Venues::Edit < Views::Base
  def initialize(venue:)
    @venue = venue
  end

  def view_template
    render Views::Layouts::Sidebar::Account.new do
      div(class: "flex items-center justify-between gap-4 mb-6") do
        Heading(level: 1) { "Edit Venue" }
      end

      render Views::Venues::Form.new(venue: @venue)
    end
  end
end
