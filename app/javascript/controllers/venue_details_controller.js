import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="venue-details"
export default class extends Controller {
  static targets = [
    "panel", "name", "type",
    "addressLine1", "addressLine2", "cityStateCountry",
    "phone", "website",
    "newVenuePanel", "newVenueName"
  ]

  connect() {
    // Pre-populate on edit forms where a radio is already checked
    const checked = this.element.querySelector(
      "input[type='radio'][name='event_venue[venue_id]']:checked"
    )
    if (checked) this._populate(checked.dataset)
  }

  update(event) {
    const input = event.target
    if (input.type !== "radio" || input.name !== "event_venue[venue_id]") return
    if (!input.checked) return

    // Hide new venue creation panel if it was open
    this.newVenuePanelTarget.classList.add("hidden")

    this._populate(input.dataset)
  }

  handleEnter(event) {
    // Only act when the combobox has no matching results (empty state is visible)
    const emptyState = this.element.querySelector("[data-ruby-ui--combobox-target='emptyState']")
    if (!emptyState || emptyState.classList.contains("hidden")) return

    const name = event.target.value?.trim()

    // Hide read-only details panel
    this.panelTarget.classList.add("hidden")

    if (!name) {
      this.newVenuePanelTarget.classList.add("hidden")
      return
    }

    // Uncheck all venue radio buttons so no venue_id is submitted
    this.element.querySelectorAll("input[type='radio'][name='event_venue[venue_id]']")
      .forEach(radio => { radio.checked = false })

    // Close the combobox popover and display the searched name in the trigger
    const popover        = this.element.querySelector("[data-ruby-ui--combobox-target='popover']")
    const trigger        = this.element.querySelector("[data-ruby-ui--combobox-target='trigger']")
    const triggerContent = this.element.querySelector("[data-ruby-ui--combobox-target='triggerContent']")
    if (popover)        popover.hidePopover()
    if (trigger)        trigger.ariaExpanded = "false"
    if (triggerContent) triggerContent.innerText = name

    // Pre-fill the venue name in the creation panel and show it
    this.newVenueNameTarget.value = name
    this.newVenuePanelTarget.classList.remove("hidden")
  }

  _populate(dataset) {
    this.nameTarget.textContent          = dataset.venueName         || ""
    this.typeTarget.textContent          = dataset.venueType         || ""
    this.addressLine1Target.textContent  = dataset.venueAddressLine1 || ""
    this.addressLine2Target.textContent  = dataset.venueAddressLine2 || ""
    this.phoneTarget.textContent         = dataset.venuePhone        || ""
    this.websiteTarget.textContent       = dataset.venueWebsite      || ""

    this.cityStateCountryTarget.textContent = [
      dataset.venueCity, dataset.venueState, dataset.venueCountry
    ].filter(Boolean).join(", ")

    this.panelTarget.classList.remove("hidden")
  }
}
