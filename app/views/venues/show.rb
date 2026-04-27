# frozen_string_literal: true

class Views::Venues::Show < Views::Base
  def initialize(venue:)
    @venue = venue
  end

  def view_template
    render Views::Layouts::Sidebar::Account.new do
      div(class: "flex items-center justify-between mb-6") do
        Heading(level: 1) { @venue.name }
        div(class: "flex items-center gap-2") do
          Link(href: edit_venue_path(@venue), variant: :outline) { "Edit" }
          Link(href: venues_path, variant: :ghost) { "Back" }
        end
      end

      div(class: "space-y-6") do
        div(class: "grid grid-cols-2 gap-4") do
          detail_item("Type") { Badge(variant: :outline) { @venue.venue_type.humanize } }
          detail_item("Phone") { @venue.phone_number }
          detail_item("Website") { @venue.website }
        end

        unless [ @venue.address_line1, @venue.address_line2, @venue.city, @venue.state, @venue.country ].all?(&:blank?)
          div do
            p(class: "text-sm font-medium text-muted-foreground mb-1") { "Address" }
            div(class: "text-sm space-y-0.5") do
              p { @venue.address_line1 } if @venue.address_line1.present?
              p { @venue.address_line2 } if @venue.address_line2.present?
              p do
                [ @venue.city, @venue.state, @venue.country ].compact_blank.join(", ")
              end
            end
          end
        end

        if @venue.notes.present?
          detail_item("Notes") { @venue.notes }
        end
      end
    end
  end

  private

  def detail_item(label, &block)
    div do
      p(class: "text-sm font-medium text-muted-foreground") { label }
      p(class: "text-sm mt-0.5") { yield }
    end
  end
end
