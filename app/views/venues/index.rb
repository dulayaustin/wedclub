# frozen_string_literal: true

class Views::Venues::Index < Views::Base
  def initialize(venues:)
    @venues = venues
  end

  def view_template
    render Views::Layouts::Sidebar::Account.new do
      div(class: "flex items-center justify-between mb-6") do
        Heading(level: 1) { "Venues" }
        Link(href: new_venue_path, variant: :primary) { "Add Venue" }
      end

      Table do
        TableHeader do
          TableRow do
            TableHead { "Name" }
            TableHead { "Type" }
            TableHead { "City" }
            TableHead { "Country" }
            TableHead { "Actions" }
          end
        end
        TableBody do
          if @venues.any?
            @venues.each do |venue|
              TableRow do
                TableCell do
                  Link(href: venue_path(venue), variant: :ghost) { venue.name }
                end
                TableCell do
                  Badge(variant: :outline) { venue.venue_type.humanize }
                end
                TableCell { venue.city }
                TableCell { venue.country }
                TableCell do
                  div(class: "flex items-center gap-2") do
                    Link(href: edit_venue_path(venue), variant: :ghost, size: :sm) { "Edit" }
                    Form(action: venue_path(venue), method: :post,
                         id: "delete-venue-#{venue.id}", style: "display:none") do
                      input(type: :hidden, name: "authenticity_token", value: form_authenticity_token, autocomplete: "off")
                      input(type: :hidden, name: "_method", value: "delete")
                      input(type: :submit, value: "Delete")
                    end
                    AlertDialog do
                      AlertDialogTrigger do
                        Button(variant: :ghost, size: :sm) { "Delete" }
                      end
                      AlertDialogContent do
                        AlertDialogHeader do
                          AlertDialogTitle { "Delete venue?" }
                          AlertDialogDescription { "This will permanently delete \"#{venue.name}\". This action cannot be undone." }
                        end
                        AlertDialogFooter do
                          AlertDialogCancel(size: :sm) { "Cancel" }
                          Button(type: :submit, form: "delete-venue-#{venue.id}",
                                 variant: :destructive, size: :sm) { "Delete" }
                        end
                      end
                    end
                  end
                end
              end
            end
          else
            TableRow do
              TableCell(class: "text-center text-muted-foreground py-8", colspan: "5") do
                "No venues yet. Add your first venue!"
              end
            end
          end
        end
      end
    end
  end
end
