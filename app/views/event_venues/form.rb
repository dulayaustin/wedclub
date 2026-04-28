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

      div(class: "grid grid-cols-2 gap-4") do
        FormField do
          FormFieldLabel { "Venue" }
          Select do
            SelectInput(name: "event_venue[venue_id]", value: @event_venue.venue_id.to_s, id: "event_venue_venue_id")
            SelectTrigger do
              SelectValue(placeholder: "Select a venue", id: "event_venue_venue_id") { @event_venue.venue&.name }
            end
            SelectContent(outlet_id: "event_venue_venue_id") do
              SelectGroup do
                @venues.each do |venue|
                  SelectItem(value: venue.id.to_s) { venue.name }
                end
              end
            end
          end
          FormFieldError { @event_venue.errors[:venue_id].first } if @event_venue.errors[:venue_id].any?
        end

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
