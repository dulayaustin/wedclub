# frozen_string_literal: true

class Views::Events::Edit < Views::Base
  def initialize(event:)
    @event = event
  end

  def view_template
    div(class: "container mx-auto py-10 px-4 max-w-md") do
      div(class: "mb-6 flex items-center gap-4") do
        Link(href: event_path(@event), variant: :ghost, size: :sm) { "← Back" }
        Heading(level: 1) { "Edit Event" }
      end

      form(action: event_path(@event), method: :post, class: "space-y-4") do
        input(type: :hidden, name: "authenticity_token", value: form_authenticity_token, autocomplete: "off")
        input(type: :hidden, name: "_method", value: "patch")

        FormField do
          FormFieldLabel(for: "event_name") { "Event Name" }
          Input(id: "event_name", type: :text, name: "event[name]", value: @event.name.to_s, required: true)
          FormFieldError { @event.errors[:name].first } if @event.errors[:name].any?
        end

        FormField do
          FormFieldLabel(for: "event_event_date") { "Event Date" }
          Input(id: "event_event_date", type: :date, name: "event[event_date]", value: @event.event_date&.to_date&.to_s)
          FormFieldError { @event.errors[:event_date].first } if @event.errors[:event_date].any?
        end

        FormField do
          FormFieldLabel(for: "event_venue") { "Venue" }
          Input(id: "event_venue", type: :text, name: "event[venue]", value: @event.venue.to_s)
          FormFieldError { @event.errors[:venue].first } if @event.errors[:venue].any?
        end

        FormField do
          FormFieldLabel(for: "event_theme") { "Theme" }
          Input(id: "event_theme", type: :text, name: "event[theme]", value: @event.theme.to_s)
          FormFieldError { @event.errors[:theme].first } if @event.errors[:theme].any?
        end

        Button(type: :submit, variant: :primary, class: "w-full") { "Save Changes" }
      end
    end
  end
end
