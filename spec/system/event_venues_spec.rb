require "rails_helper"

RSpec.describe "EventVenues", type: :system do
  let(:user) { create(:user) }
  let!(:account) { create(:account).tap { |a| a.account_users.create!(user: user) } }
  let!(:event) { create(:event, account: account) }
  let!(:venue) { create(:venue, name: "Grand Ballroom") }

  before do
    sign_in_as(user)
    select_account(account)
  end

  describe "GET /event_venues" do
    context "with no venues assigned" do
      before { visit event_venues_path }

      it "shows the empty state message" do
        expect(page).to have_text("No venues assigned yet.")
      end

      it "shows the Assign Venue link" do
        expect(page).to have_link("Assign Venue", href: new_event_venue_path)
      end
    end

    context "with venues assigned" do
      let!(:event_venue) { create(:event_venue, event: event, venue: venue, role: :ceremony) }

      before { visit event_venues_path }

      it "loads the venues page" do
        expect(page).to have_css("h1", text: "Venues")
      end

      it "displays the assigned venue" do
        expect(page).to have_css("td", text: "Grand Ballroom")
        expect(page).to have_css("td", text: "Ceremony")
      end
    end

    context "with both roles taken" do
      let!(:venue2) { create(:venue, name: "Garden Chapel") }
      let!(:ceremony_venue) { create(:event_venue, event: event, venue: venue, role: :ceremony) }
      let!(:reception_venue) { create(:event_venue, event: event, venue: venue2, role: :reception) }

      before { visit event_venues_path }

      it "does not show the Assign Venue link" do
        expect(page).not_to have_link("Assign Venue")
      end
    end
  end

  describe "GET /event_venues/new" do
    before { visit new_event_venue_path }

    it "loads the assign venue page" do
      expect(page).to have_css("h1", text: "Assign Venue")
    end

    it "has an Assign Venue button" do
      expect(page).to have_button("Assign Venue")
    end
  end

  describe "POST /event_venues" do
    before { visit new_event_venue_path }

    context "with valid data" do
      it "creates a venue assignment and redirects to index" do
        find("input[name='event_venue[venue_id]'][value='#{venue.id}']", visible: false).set(true)
        find("input#event_venue_role", visible: false).set("ceremony")
        click_button "Assign Venue"

        expect(page).to have_current_path(event_venues_path)
        expect(page).to have_css("td", text: "Grand Ballroom")
        expect(page).to have_css("td", text: "Ceremony")
      end
    end

    # context "with a new venue name not in the list" do
    #   it "closes the combobox, shows the searched name in the trigger, and reveals the new venue form" do
    #     click_button "Select a venue"
    #     find("[data-ruby-ui--combobox-target='searchInput']").fill_in with: "Rooftop Garden"
    #     expect(page).to have_css("[data-ruby-ui--combobox-target='emptyState']:not(.hidden)")

    #     find("[data-ruby-ui--combobox-target='searchInput']").send_keys(:return)

    #     expect(page).not_to have_css("[data-ruby-ui--combobox-target='popover']:popover-open")
    #     expect(find("[data-ruby-ui--combobox-target='triggerContent']")).to have_text("Rooftop Garden")
    #     expect(page).to have_field("venue[name]", with: "Rooftop Garden")
    #     expect(page).not_to have_css("input[name='event_venue[venue_id]']:checked", visible: false)
    #   end

    #   it "creates a new venue and assignment when the new venue form is submitted" do
    #     click_button "Select a venue"
    #     find("[data-ruby-ui--combobox-target='searchInput']").fill_in with: "Rooftop Garden"
    #     find("[data-ruby-ui--combobox-target='searchInput']").send_keys(:return)

    #     fill_in "venue[name]", with: "Rooftop Garden"
    #     find("input#event_venue_role", visible: false).set("ceremony")
    #     click_button "Assign Venue"

    #     expect(page).to have_current_path(event_venues_path)
    #     expect(page).to have_css("td", text: "Rooftop Garden")
    #   end
    # end
  end

  describe "GET /event_venues/:id/edit" do
    let!(:event_venue) { create(:event_venue, event: event, venue: venue, role: :ceremony) }

    before { visit edit_event_venue_path(event_venue) }

    it "loads the edit page" do
      expect(page).to have_css("h1", text: "Edit Venue Assignment")
    end

    it "has an Update Assignment button" do
      expect(page).to have_button("Update Assignment")
    end
  end

  describe "PATCH /event_venues/:id" do
    let!(:venue2) { create(:venue, name: "Beachfront Resort") }
    let!(:event_venue) { create(:event_venue, event: event, venue: venue, role: :ceremony) }

    it "updates the venue assignment" do
      visit edit_event_venue_path(event_venue)
      find("input[name='event_venue[venue_id]'][value='#{venue2.id}']", visible: false).set(true)
      click_button "Update Assignment"

      expect(page).to have_current_path(event_venues_path)
      expect(page).to have_text("Venue assignment updated.")
      expect(page).to have_css("td", text: "Beachfront Resort")
    end
  end

  describe "DELETE /event_venues/:id" do
    let!(:event_venue) { create(:event_venue, event: event, venue: venue, role: :ceremony) }

    it "removes the venue assignment" do
      visit event_venues_path
      find("form#delete-event-venue-#{event_venue.id} input[type=submit]", visible: false).click

      expect(page).to have_current_path(event_venues_path)
      expect(page).to have_text("Venue assignment removed.")
      expect(page).to have_text("No venues assigned yet.")
    end
  end

  describe "uniqueness enforcement" do
    let!(:event_venue) { create(:event_venue, event: event, venue: venue, role: :ceremony) }

    it "prevents assigning the same role twice" do
      venue2 = create(:venue, name: "Another Venue")
      visit new_event_venue_path
      find("input[name='event_venue[venue_id]'][value='#{venue2.id}']", visible: false).set(true)
      find("input#event_venue_role", visible: false).set("ceremony")
      click_button "Assign Venue"

      expect(page).to have_css("h1", text: "Assign Venue")
    end
  end
end
