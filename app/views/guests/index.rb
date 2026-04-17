# frozen_string_literal: true

class Views::Guests::Index < Views::Base
  def initialize(guests:)
    @guests = guests
  end

  def view_template
    render Views::Layouts::Sidebar::Event.new do
      div(class: "flex items-center justify-between mb-6") do
        Heading(level: 1) { "Guest List" }
        Link(href: new_guest_path, variant: :primary) { "Add Guest" }
      end

      Table do
        TableHeader do
          TableRow do
            TableHead { "First Name" }
            TableHead { "Last Name" }
            TableHead { "Age Group" }
            TableHead { "Guest Of" }
            TableHead { "Category" }
            TableHead { "Actions" }
          end
        end
        TableBody do
          if @guests.any?
            @guests.each do |guest|
              TableRow do
                TableCell { guest.first_name }
                TableCell { guest.last_name }
                TableCell do
                  Badge(variant: :outline) { guest.age_group.humanize } if guest.age_group
                end
                TableCell do
                  Badge(variant: :outline) { guest.guest_of.humanize } if guest.guest_of
                end
                TableCell { guest.guest_category&.name }
                TableCell do
                  div(class: "flex items-center gap-2") do
                    Link(href: edit_guest_path(guest), variant: :ghost, size: :sm) { "Edit" }
                    Form(action: guest_path(guest), method: :post,
                         id: "delete-guest-#{guest.id}", style: "display:none") do
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
                          AlertDialogTitle { "Delete guest?" }
                          AlertDialogDescription { "This will permanently delete #{guest.first_name} #{guest.last_name}. This action cannot be undone." }
                        end
                        AlertDialogFooter do
                          AlertDialogCancel(size: :sm) { "Cancel" }
                          Button(type: :submit, form: "delete-guest-#{guest.id}",
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
              TableCell(class: "text-center text-muted-foreground py-8", colspan: "6") do
                "No guests yet. Add your first guest!"
              end
            end
          end
        end
      end
    end
  end
end
