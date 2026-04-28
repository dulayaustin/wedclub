# frozen_string_literal: true

class Views::EventVenues::Index < Views::Base
  def initialize(event_venues:)
    @event_venues = event_venues
  end

  def view_template
    render Views::Layouts::Sidebar::Event.new do
      div(class: "flex items-center justify-between mb-6") do
        Heading(level: 1) { "Venues" }
        Link(href: new_event_venue_path, variant: :primary) { "Assign Venue" } if @event_venues.size < 2
      end

      Table do
        TableHeader do
          TableRow do
            TableHead { "Role" }
            TableHead { "Venue" }
            TableHead { "Start" }
            TableHead { "End" }
            TableHead { "Notes" }
            TableHead { "Actions" }
          end
        end
        TableBody do
          if @event_venues.any?
            @event_venues.each do |ev|
              TableRow do
                TableCell do
                  Badge(variant: :outline) { ev.role.humanize }
                end
                TableCell { ev.venue.name }
                TableCell { ev.start_at&.strftime("%b %-d, %Y %l:%M %p") }
                TableCell { ev.end_at&.strftime("%b %-d, %Y %l:%M %p") }
                TableCell { ev.notes&.truncate(50) }
                TableCell do
                  div(class: "flex items-center gap-2") do
                    Link(href: edit_event_venue_path(ev), variant: :ghost, size: :sm) { "Edit" }
                    Form(action: event_venue_path(ev), method: :post,
                         id: "delete-event-venue-#{ev.id}", style: "display:none") do
                      input(type: :hidden, name: "authenticity_token", value: form_authenticity_token, autocomplete: "off")
                      input(type: :hidden, name: "_method", value: "delete")
                      input(type: :submit, value: "Delete")
                    end
                    AlertDialog do
                      AlertDialogTrigger do
                        Button(variant: :ghost, size: :sm) { "Remove" }
                      end
                      AlertDialogContent do
                        AlertDialogHeader do
                          AlertDialogTitle { "Remove venue assignment?" }
                          AlertDialogDescription { "This will remove #{ev.venue.name} as the #{ev.role} venue. This action cannot be undone." }
                        end
                        AlertDialogFooter do
                          AlertDialogCancel(size: :sm) { "Cancel" }
                          Button(type: :submit, form: "delete-event-venue-#{ev.id}",
                                 variant: :destructive, size: :sm) { "Remove" }
                        end
                      end
                    end
                  end
                end
              end
            end
          else
            TableRow do
              TableCell(class: "text-center text-muted-foreground py-8", colspan: "6") do
                "No venues assigned yet."
              end
            end
          end
        end
      end
    end
  end
end
