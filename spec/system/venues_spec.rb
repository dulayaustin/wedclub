require "rails_helper"

RSpec.describe "Venues", type: :system do
  let(:user) { create(:user) }

  before { sign_in_as(user) }

  describe "GET /venues" do
    context "with no venues" do
      before { visit venues_path }

      it "loads the venues page" do
        expect(page).to have_css("h1", text: "Venues")
      end

      it "has an Add Venue link" do
        expect(page).to have_link("Add Venue", href: new_venue_path)
      end

      it "shows the empty state message" do
        expect(page).to have_text("No venues yet. Add your first venue!")
      end
    end

    context "with existing venues" do
      let!(:venue) { create(:venue, name: "Seaside Garden", venue_type: :garden, city: "Miami", country: "USA") }

      before { visit venues_path }

      it "displays the venue name" do
        expect(page).to have_css("td", text: "Seaside Garden")
      end

      it "displays the venue type badge" do
        expect(page).to have_css("td", text: "Garden")
      end

      it "displays the city and country" do
        expect(page).to have_css("td", text: "Miami")
        expect(page).to have_css("td", text: "USA")
      end

      it "has Edit and Delete actions" do
        expect(page).to have_link("Edit")
        expect(page).to have_button("Delete")
      end
    end
  end

  describe "GET /venues/new" do
    before { visit new_venue_path }

    it "loads the add venue page" do
      expect(page).to have_css("h1", text: "Add Venue")
    end

    it "has a Name field" do
      expect(page).to have_field("venue_name")
    end

    it "has address fields" do
      expect(page).to have_field("venue_address_line1")
      expect(page).to have_field("venue_city")
      expect(page).to have_field("venue_state")
      expect(page).to have_field("venue_country")
    end

    it "has phone and website fields" do
      expect(page).to have_field("venue_phone_number")
      expect(page).to have_field("venue_website")
    end

    it "has an Add Venue button" do
      expect(page).to have_button("Add Venue")
    end

    context "with valid data" do
      it "creates a venue and redirects to venues index" do
        fill_in "venue_name", with: "The Rosewood Estate"
        # RubyUI SelectInput renders as a CSS-hidden input (class: "hidden"), not type="hidden"
        find('input[name="venue[venue_type]"]', visible: :all).set("hotel")
        fill_in "venue_city", with: "Beverly Hills"
        fill_in "venue_country", with: "USA"
        click_button "Add Venue"

        expect(page).to have_current_path(venues_path)
        expect(page).to have_css("td", text: "The Rosewood Estate")
      end
    end

    context "with missing name" do
      it "re-renders the form with an error" do
        find('input[name="venue[venue_type]"]', visible: :all).set("beach")
        click_button "Add Venue"

        expect(page).to have_css("h1", text: "Add Venue")
      end
    end
  end

  describe "GET /venues/:id" do
    let!(:venue) { create(:venue, name: "Crystal Ballroom", venue_type: :hall, city: "Chicago", country: "USA", phone_number: "+1-312-555-0100", notes: "Parking available") }

    before { visit venue_path(venue) }

    it "loads the venue detail page" do
      expect(page).to have_css("h1", text: "Crystal Ballroom")
    end

    it "displays the venue type" do
      expect(page).to have_text("Hall")
    end

    it "displays the city and country" do
      expect(page).to have_text("Chicago")
      expect(page).to have_text("USA")
    end

    it "displays the phone number" do
      expect(page).to have_text("+1-312-555-0100")
    end

    it "displays notes" do
      expect(page).to have_text("Parking available")
    end

    it "has Edit and Back links" do
      expect(page).to have_link("Edit")
      expect(page).to have_link("Back")
    end
  end

  describe "GET /venues/:id/edit" do
    let!(:venue) { create(:venue, name: "Old Barn", venue_type: :garden) }

    before { visit edit_venue_path(venue) }

    it "loads the edit venue page" do
      expect(page).to have_css("h1", text: "Edit Venue")
    end

    it "pre-fills the name field" do
      expect(page).to have_field("venue_name", with: "Old Barn")
    end

    it "has an Update Venue button" do
      expect(page).to have_button("Update Venue")
    end

    context "with valid data" do
      it "updates the venue and redirects to venues index" do
        fill_in "venue_name", with: "New Barn"
        fill_in "venue_city", with: "Nashville"
        click_button "Update Venue"

        expect(page).to have_current_path(venues_path)
        expect(page).to have_css("td", text: "New Barn")
      end
    end

    context "with blank name" do
      it "re-renders the form with an error" do
        fill_in "venue_name", with: ""
        click_button "Update Venue"

        expect(page).to have_css("h1", text: "Edit Venue")
      end
    end
  end

  describe "DELETE /venues/:id" do
    let!(:venue) { create(:venue, name: "The Teardown Terrace", venue_type: :beach) }

    it "deletes the venue and returns to venues index" do
      visit venues_path
      expect(page).to have_css("td", text: "The Teardown Terrace")

      # Submit the hidden delete form directly (AlertDialog confirmation requires JS)
      page.driver.delete(venue_path(venue))
      visit venues_path

      expect(page).not_to have_css("td", text: "The Teardown Terrace")
    end
  end
end
