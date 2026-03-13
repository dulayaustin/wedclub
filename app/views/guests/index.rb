# frozen_string_literal: true

class Views::Guests::Index < Views::Base
  def initialize(guests:)
    @guests = guests
  end

  def view_template
    div(class: "container mx-auto py-10 px-4") do
      div(class: "flex items-center justify-between mb-6") do
        Heading(level: 1) { "Guest List" }
        Link(href: new_guest_path, variant: :primary) { "Add Guest" }
      end

      Table do
        TableHeader do
          TableRow do
            TableHead { "First Name" }
            TableHead { "Last Name" }
            TableHead { "Category" }
          end
        end
        TableBody do
          if @guests.any?
            @guests.each do |guest|
              TableRow do
                TableCell { guest.first_name }
                TableCell { guest.last_name }
                TableCell { guest.guest_category&.name }
              end
            end
          else
            TableRow do
              TableCell(class: "text-center text-muted-foreground py-8", colspan: "3") do
                "No guests yet. Add your first guest!"
              end
            end
          end
        end
      end
    end
  end
end
