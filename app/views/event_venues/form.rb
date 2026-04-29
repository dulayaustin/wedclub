# frozen_string_literal: true

class Views::EventVenues::Form < Views::Base
  def initialize(event_venue:, venues:, available_roles:)
    @event_venue = event_venue
    @venues = venues
    @available_roles = available_roles
  end

  def view_template
    Form(action: form_url, method: :post, class: "space-y-4") do
      input(type: :hidden, name: "authenticity_token", value: form_authenticity_token, autocomplete: "off")
      input(type: :hidden, name: "_method", value: "patch") if @event_venue.persisted?

      div(data: { controller: "venue-details", action: "change->venue-details#update keydown.enter->venue-details#handleEnter" }) do
        FormField do
          FormFieldLabel { "Venue" }
          Combobox(term: @event_venue.venue&.name) do
            ComboboxTrigger(placeholder: "Select a venue")
            ComboboxPopover do
              ComboboxSearchInput(placeholder: "Search venues...")
              ComboboxList do
                @venues.each do |venue|
                  ComboboxItem do
                    ComboboxRadio(
                      name: "event_venue[venue_id]",
                      value: venue.id.to_s,
                      checked: @event_venue.venue_id == venue.id,
                      data: {
                        venue_name:          venue.name,
                        venue_type:          venue.venue_type&.humanize,
                        venue_address_line1: venue.address_line1.to_s,
                        venue_address_line2: venue.address_line2.to_s,
                        venue_city:          venue.city.to_s,
                        venue_state:         venue.state.to_s,
                        venue_country:       venue.country.to_s,
                        venue_phone:         venue.phone_number.to_s,
                        venue_website:       venue.website.to_s
                      }
                    )
                    span(class: "truncate") { venue.name }
                  end
                end
                ComboboxEmptyState do
                  p(class: "text-muted-foreground") { "No venue found. Press Enter to add it." }
                end
              end
            end
          end
          FormFieldError { @event_venue.errors[:venue_id].first } if @event_venue.errors[:venue_id].any?
        end

        # Read-only details panel — shown when an existing venue is selected
        div(
          data: { venue_details_target: "panel" },
          class: "hidden mt-3 p-4 rounded-lg border bg-muted/50 space-y-2 text-sm"
        ) do
          div(class: "grid grid-cols-2 gap-x-4 gap-y-2") do
            div do
              span(class: "font-medium text-muted-foreground") { "Name" }
              p(data: { venue_details_target: "name" }) { }
            end
            div do
              span(class: "font-medium text-muted-foreground") { "Type" }
              p(data: { venue_details_target: "type" }) { }
            end
            div(class: "col-span-2") do
              span(class: "font-medium text-muted-foreground") { "Address" }
              p(data: { venue_details_target: "addressLine1" }) { }
              p(data: { venue_details_target: "addressLine2" }) { }
              p(data: { venue_details_target: "cityStateCountry" }) { }
            end
            div do
              span(class: "font-medium text-muted-foreground") { "Phone" }
              p(data: { venue_details_target: "phone" }) { }
            end
            div do
              span(class: "font-medium text-muted-foreground") { "Website" }
              p(data: { venue_details_target: "website" }) { }
            end
          end
        end

        # New venue creation panel — shown when no venue is found in the combobox
        div(
          data: { venue_details_target: "newVenuePanel" },
          class: "hidden mt-3 p-4 rounded-lg border space-y-4"
        ) do
          p(class: "text-sm font-medium") { "New Venue" }

          div(class: "grid grid-cols-2 gap-4") do
            FormField do
              FormFieldLabel(for: "venue_name") { "Name" }
              Input(
                id: "venue_name",
                type: :text,
                name: "venue[name]",
                placeholder: "Enter venue name",
                data: { venue_details_target: "newVenueName" }
              )
            end

            FormField do
              FormFieldLabel { "Type" }
              Select do
                SelectInput(name: "venue[venue_type]", value: "", id: "venue_venue_type")
                SelectTrigger do
                  SelectValue(placeholder: "Select venue type", id: "venue_venue_type")
                end
                SelectContent(outlet_id: "venue_venue_type") do
                  SelectGroup do
                    Venue.venue_types.each_key do |type|
                      SelectItem(value: type) { type.humanize }
                    end
                  end
                end
              end
            end
          end

          FormField do
            FormFieldLabel(for: "venue_address_line1") { "Address Line 1" }
            Input(id: "venue_address_line1", type: :text, name: "venue[address_line1]", placeholder: "Street address")
          end

          FormField do
            FormFieldLabel(for: "venue_address_line2") { "Address Line 2" }
            Input(id: "venue_address_line2", type: :text, name: "venue[address_line2]", placeholder: "Apt, suite, unit, etc.")
          end

          div(class: "grid grid-cols-3 gap-4") do
            FormField do
              FormFieldLabel(for: "venue_city") { "City" }
              Input(id: "venue_city", type: :text, name: "venue[city]", placeholder: "City")
            end

            FormField do
              FormFieldLabel(for: "venue_state") { "State / Province" }
              Input(id: "venue_state", type: :text, name: "venue[state]", placeholder: "State")
            end

            FormField do
              FormFieldLabel(for: "venue_country") { "Country" }
              Input(id: "venue_country", type: :text, name: "venue[country]", placeholder: "Country")
            end
          end

          div(class: "grid grid-cols-2 gap-4") do
            FormField do
              FormFieldLabel(for: "venue_phone_number") { "Phone Number" }
              Input(id: "venue_phone_number", type: :tel, name: "venue[phone_number]", placeholder: "+1 (555) 000-0000")
            end

            FormField do
              FormFieldLabel(for: "venue_website") { "Website" }
              Input(id: "venue_website", type: :url, name: "venue[website]", placeholder: "https://example.com")
            end
          end
        end
      end

      div(class: "grid grid-cols-2 gap-4") do
        FormField do
          FormFieldLabel { "Role" }
          Select do
            SelectInput(name: "event_venue[role]", value: @event_venue.role.to_s, id: "event_venue_role")
            SelectTrigger do
              SelectValue(placeholder: "Select a role", id: "event_venue_role") { @event_venue.role&.humanize }
            end
            SelectContent(outlet_id: "event_venue_role") do
              SelectGroup do
                @available_roles.each do |role|
                  SelectItem(value: role) { role.humanize }
                end
              end
            end
          end
          FormFieldError { @event_venue.errors[:role].first } if @event_venue.errors[:role].any?
        end
      end

      div(class: "grid grid-cols-2 gap-4") do
        FormField do
          FormFieldLabel(for: "event_venue_start_at") { "Start Time" }
          Input(
            id: "event_venue_start_at",
            type: "datetime-local",
            name: "event_venue[start_at]",
            value: @event_venue.start_at&.strftime("%Y-%m-%dT%H:%M").to_s
          )
          FormFieldError { @event_venue.errors[:start_at].first } if @event_venue.errors[:start_at].any?
        end

        FormField do
          FormFieldLabel(for: "event_venue_end_at") { "End Time" }
          Input(
            id: "event_venue_end_at",
            type: "datetime-local",
            name: "event_venue[end_at]",
            value: @event_venue.end_at&.strftime("%Y-%m-%dT%H:%M").to_s
          )
          FormFieldError { @event_venue.errors[:end_at].first } if @event_venue.errors[:end_at].any?
        end
      end

      FormField do
        FormFieldLabel(for: "event_venue_notes") { "Notes" }
        Textarea(id: "event_venue_notes", name: "event_venue[notes]", rows: "3") { @event_venue.notes.to_s }
        FormFieldError { @event_venue.errors[:notes].first } if @event_venue.errors[:notes].any?
      end

      Button(type: :submit, variant: :primary, class: "w-full") { submit_label }
    end
  end

  private

  def form_url     = @event_venue.persisted? ? event_venue_path(@event_venue) : event_venues_path
  def submit_label = @event_venue.persisted? ? "Update Assignment" : "Assign Venue"
end
