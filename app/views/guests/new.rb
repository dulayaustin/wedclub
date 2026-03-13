# frozen_string_literal: true

class Views::Guests::New < Views::Base
  def initialize(guest:, categories:)
    @guest = guest
    @categories = categories
  end

  def view_template
    div(class: "container mx-auto py-10 px-4 max-w-md") do
      div(class: "mb-6 flex items-center gap-4") do
        Link(href: guests_path, variant: :ghost, size: :sm) { "← Back" }
        Heading(level: 1) { "Add Guest" }
      end

      form(action: guests_path, method: :post, class: "space-y-4") do
        input(type: :hidden, name: "authenticity_token", value: form_authenticity_token, autocomplete: "off")

        FormField do
          FormFieldLabel(for: "guest_first_name") { "First Name" }
          Input(
            id: "guest_first_name",
            type: :text,
            name: "guest[first_name]",
            value: @guest.first_name.to_s,
            placeholder: "Enter first name",
            required: true
          )
          if @guest.errors[:first_name].any?
            FormFieldError { @guest.errors[:first_name].first }
          end
        end

        FormField do
          FormFieldLabel(for: "guest_last_name") { "Last Name" }
          Input(
            id: "guest_last_name",
            type: :text,
            name: "guest[last_name]",
            value: @guest.last_name.to_s,
            placeholder: "Enter last name",
            required: true
          )
          if @guest.errors[:last_name].any?
            FormFieldError { @guest.errors[:last_name].first }
          end
        end

        FormField do
          FormFieldLabel { "Category" }
          div(class: "space-y-2 mt-1") do
            label(class: "flex items-center gap-2 cursor-pointer") do
              input(
                type: :radio,
                name: "guest[guest_category_id]",
                value: "",
                checked: @guest.guest_category.nil?
              )
              span { "None" }
            end
            @categories.each do |category|
              label(class: "flex items-center gap-2 cursor-pointer") do
                input(
                  type: :radio,
                  name: "guest[guest_category_id]",
                  value: category.id,
                  checked: @guest.guest_category&.id == category.id
                )
                span { category.name }
              end
            end
          end
        end

        Button(type: :submit, variant: :primary, class: "w-full") { "Add Guest" }
      end
    end
  end
end
