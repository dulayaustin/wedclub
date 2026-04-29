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
    const name = event.target.value.trim()

    // Hide read-only details panel
    this.panelTarget.classList.add("hidden")

    if (name.length === 0) {
      this.newVenuePanelTarget.classList.add("hidden")
      return
    }

    // Pre-fill the venue name in the creation panel
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
