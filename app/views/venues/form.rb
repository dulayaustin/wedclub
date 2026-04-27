# frozen_string_literal: true

class Views::Venues::Form < Views::Base
  def initialize(venue:)
    @venue = venue
  end

  def view_template
    Form(action: form_url, method: :post, class: "space-y-4") do
      input(type: :hidden, name: "authenticity_token", value: form_authenticity_token, autocomplete: "off")
      input(type: :hidden, name: "_method", value: "patch") if @venue.persisted?

      div(class: "grid grid-cols-2 gap-4") do
        FormField do
          FormFieldLabel(for: "venue_name") { "Name" }
          Input(
            id: "venue_name",
            type: :text,
            name: "venue[name]",
            value: @venue.name.to_s,
            placeholder: "Enter venue name",
            required: true
          )
          FormFieldError { @venue.errors[:name].first } if @venue.errors[:name].any?
        end

        FormField do
          FormFieldLabel { "Type" }
          Select do
            SelectInput(name: "venue[venue_type]", value: @venue.venue_type.to_s, id: "venue_venue_type")
            SelectTrigger do
              SelectValue(placeholder: "Select venue type", id: "venue_venue_type") { @venue.venue_type&.humanize }
            end
            SelectContent(outlet_id: "venue_venue_type") do
              SelectGroup do
                Venue.venue_types.each_key do |type|
                  SelectItem(value: type) { type.humanize }
                end
              end
            end
          end
          FormFieldError { @venue.errors[:venue_type].first } if @venue.errors[:venue_type].any?
        end
      end

      FormField do
        FormFieldLabel(for: "venue_address_line1") { "Address Line 1" }
        Input(
          id: "venue_address_line1",
          type: :text,
          name: "venue[address_line1]",
          value: @venue.address_line1.to_s,
          placeholder: "Street address"
        )
      end

      FormField do
        FormFieldLabel(for: "venue_address_line2") { "Address Line 2" }
        Input(
          id: "venue_address_line2",
          type: :text,
          name: "venue[address_line2]",
          value: @venue.address_line2.to_s,
          placeholder: "Apt, suite, unit, etc."
        )
      end

      div(class: "grid grid-cols-3 gap-4") do
        FormField do
          FormFieldLabel(for: "venue_city") { "City" }
          Input(
            id: "venue_city",
            type: :text,
            name: "venue[city]",
            value: @venue.city.to_s,
            placeholder: "City"
          )
        end

        FormField do
          FormFieldLabel(for: "venue_state") { "State / Province" }
          Input(
            id: "venue_state",
            type: :text,
            name: "venue[state]",
            value: @venue.state.to_s,
            placeholder: "State"
          )
        end

        FormField do
          FormFieldLabel(for: "venue_country") { "Country" }
          Input(
            id: "venue_country",
            type: :text,
            name: "venue[country]",
            value: @venue.country.to_s,
            placeholder: "Country"
          )
        end
      end

      div(class: "grid grid-cols-2 gap-4") do
        FormField do
          FormFieldLabel(for: "venue_phone_number") { "Phone Number" }
          Input(
            id: "venue_phone_number",
            type: :tel,
            name: "venue[phone_number]",
            value: @venue.phone_number.to_s,
            placeholder: "+1 (555) 000-0000"
          )
        end

        FormField do
          FormFieldLabel(for: "venue_website") { "Website" }
          Input(
            id: "venue_website",
            type: :url,
            name: "venue[website]",
            value: @venue.website.to_s,
            placeholder: "https://example.com"
          )
        end
      end

      FormField do
        FormFieldLabel(for: "venue_notes") { "Notes" }
        Textarea(
          id: "venue_notes",
          name: "venue[notes]",
          placeholder: "Any additional notes about the venue",
          rows: "3"
        ) { @venue.notes.to_s }
      end

      Button(type: :submit, variant: :primary, class: "w-full") { submit_label }
    end
  end

  private

  def form_url     = @venue.persisted? ? venue_path(@venue) : venues_path
  def submit_label = @venue.persisted? ? "Update Venue" : "Add Venue"
end
