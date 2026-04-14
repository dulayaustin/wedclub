# frozen_string_literal: true

class Views::Events::Edit < Views::Base
  def initialize(event:)
    @event = event
  end

  def view_template
    render Views::Layouts::Sidebar::Event.new do
      div(class: "flex items-center justify-between gap-4 mb-6 ") do
        Heading(level: 1) { "Edit Event" }
      end

      form(action: event_path(@event), method: :post, class: "space-y-4") do
        input(type: :hidden, name: "authenticity_token", value: form_authenticity_token, autocomplete: "off")
        input(type: :hidden, name: "_method", value: "patch")

        div(class: "grid grid-cols-2 gap-4") do
          FormField do
            FormFieldLabel(for: "event_title") { "Event Name" }
            Input(id: "event_title", type: :text, name: "event[title]", value: @event.title.to_s, required: true)
            FormFieldError { @event.errors[:title].first } if @event.errors[:title].any?
          end

          FormField do
            FormFieldLabel(for: "event_event_date") { "Event Date" }
            Input(id: "event_event_date", type: :date, name: "event[event_date]", value: @event.event_date&.to_date&.to_s)
            FormFieldError { @event.errors[:event_date].first } if @event.errors[:event_date].any?
          end
        end

        div(class: "grid grid-cols-2 gap-4") do
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
        end

        Button(type: :submit, variant: :primary, class: "w-full") { "Save Changes" }
      end
    end
  end
end
