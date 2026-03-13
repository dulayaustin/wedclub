# frozen_string_literal: true

class Views::GuestCategories::Index < Views::Base
  def initialize(guest_categories:)
    @guest_categories = guest_categories
  end

  def view_template
    div(class: "container mx-auto py-10 px-4") do
      div(class: "flex items-center justify-between mb-6") do
        Heading(level: 1) { "Guest Categories" }
        Link(href: new_guest_category_path, variant: :primary) { "Add Category" }
      end

      Table do
        TableHeader do
          TableRow do
            TableHead { "Name" }
            TableHead { "Actions" }
          end
        end
        TableBody do
          if @guest_categories.any?
            @guest_categories.each do |category|
              TableRow do
                TableCell { category.name }
                TableCell do
                  div(class: "flex items-center gap-2") do
                    Link(href: edit_guest_category_path(category), variant: :ghost, size: :sm) { "Edit" }
                    form(action: guest_category_path(category), method: :post) do
                      input(type: :hidden, name: "authenticity_token", value: form_authenticity_token, autocomplete: "off")
                      input(type: :hidden, name: "_method", value: "delete")
                      Button(type: :submit, variant: :ghost, size: :sm) { "Delete" }
                    end
                  end
                end
              end
            end
          else
            TableRow do
              TableCell(class: "text-center text-muted-foreground py-8", colspan: "2") do
                "No categories yet. Add your first category!"
              end
            end
          end
        end
      end
    end
  end
end
