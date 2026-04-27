# frozen_string_literal: true

class Views::Events::Form < Views::Base
  def initialize(event:)
    @event = event
  end

  def view_template
    Form(action: form_url, method: :post, class: "space-y-4") do
      input(type: :hidden, name: "authenticity_token", value: form_authenticity_token, autocomplete: "off")
      input(type: :hidden, name: "_method", value: "patch") if @event.persisted?

      div(class: "grid grid-cols-2 gap-4") do
        FormField do
          FormFieldLabel(for: "event_title") { "Event Name" }
          Input(id: "event_title", type: :text, name: "event[title]", value: @event.title.to_s, required: true)
          FormFieldError { @event.errors[:title].first } if @event.errors[:title].any?
        end

        FormField do
          FormFieldLabel(for: "event_event_date") { "Event Date" }
          Popover(options: { trigger: "click" }) do
            PopoverTrigger(class: "w-full") do
              Input(
                type: :string,
                placeholder: "Select a date",
                id: "event_event_date",
                name: "event[event_date]",
                value: @event.event_date&.to_date&.to_s,
                data_controller: "ruby-ui--calendar-input"
              )
            end
            PopoverContent do
              Calendar(input_id: "#event_event_date", selected_date: @event.event_date&.to_date)
            end
          end
          FormFieldError { @event.errors[:event_date].first } if @event.errors[:event_date].any?
        end
      end

      FormField do
        FormFieldLabel(for: "event_theme") { "Theme" }
        Input(id: "event_theme", type: :text, name: "event[theme]", value: @event.theme.to_s)
        FormFieldError { @event.errors[:theme].first } if @event.errors[:theme].any?
      end

      Button(type: :submit, variant: :primary, class: "w-full") { submit_label }
    end
  end

  private

  def form_url     = @event.persisted? ? event_path(@event) : events_path
  def submit_label = @event.persisted? ? "Save Changes" : "Create Event"
end
