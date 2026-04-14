# frozen_string_literal: true

class Views::GuestCategories::New < Views::Base
  def initialize(guest_category:)
    @guest_category = guest_category
  end

  def view_template
    render Views::Layouts::Sidebar::Event.new do
      div(class: "flex items-center justify-between gap-4 mb-6 ") do
        Heading(level: 1) { "Add Category" }
      end

      form(action: guest_categories_path, method: :post, class: "space-y-4") do
        input(type: :hidden, name: "authenticity_token", value: form_authenticity_token, autocomplete: "off")

        FormField do
          FormFieldLabel(for: "guest_category_name") { "Name" }
          Input(
            id: "guest_category_name",
            type: :text,
            name: "guest_category[name]",
            value: @guest_category.name.to_s,
            placeholder: "Enter category name",
            required: true
          )
          if @guest_category.errors[:name].any?
            FormFieldError { @guest_category.errors[:name].first }
          end
        end

        Button(type: :submit, variant: :primary, class: "w-full") { "Add Category" }
      end
    end
  end
end
