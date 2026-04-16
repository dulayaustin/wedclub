require "rails_helper"

RSpec.describe "Guests", type: :system do
  let(:user) { create(:user) }
  let!(:account) { create(:account).tap { |a| a.account_users.create!(user: user) } }
  let!(:event) { create(:event, account: account) }

  before do
    sign_in_as(user)
    select_account(account) # redirects to event show, setting event session
  end

  describe "GET /guests" do
    context "with existing guests" do
      let!(:guest) { event.guests.create!(first_name: "Alice", last_name: "Smith") }

      before { visit guests_path }

      it "loads the guest list page" do
        expect(page).to have_css("h1", text: "Guest List")
      end

      it "has an Add Guest link" do
        expect(page).to have_link("Add Guest", href: new_guest_path)
      end

      it "displays the guest's name" do
        expect(page).to have_css("td", text: "Alice")
        expect(page).to have_css("td", text: "Smith")
      end
    end

    context "with no guests" do
      before { visit guests_path }

      it "shows the empty state message" do
        expect(page).to have_text("No guests yet. Add your first guest!")
      end
    end
  end

  describe "GET /guests/new" do
    before { visit new_guest_path }

    it "loads the add guest page" do
      expect(page).to have_css("h1", text: "Add Guest")
    end

    it "has First Name and Last Name fields" do
      expect(page).to have_field("guest_first_name")
      expect(page).to have_field("guest_last_name")
    end

    it "has an Add Guest button" do
      expect(page).to have_button("Add Guest")
    end

    context "with valid data" do
      it "creates a guest and redirects to guests index" do
        fill_in "guest_first_name", with: "Bob"
        fill_in "guest_last_name", with: "Jones"
        click_button "Add Guest"

        expect(page).to have_current_path(guests_path)
        expect(page).to have_css("td", text: "Bob")
        expect(page).to have_css("td", text: "Jones")
      end
    end
  end
end
