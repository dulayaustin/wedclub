require "rails_helper"

RSpec.describe "Events", type: :system do
  let(:user) { create(:user) }
  let!(:account) { create(:account).tap { |a| a.account_users.create!(user: user) } }
  let!(:event) do
    create(:event, account: account, title: "Smith & Jones Wedding",
           event_date: Date.new(2026, 6, 15), theme: "Black Tie")
  end

  before do
    sign_in_as(user)
    select_account(account) # with 1 event, redirects to event show and sets event session
  end

  describe "GET /events" do
    before { visit events_path }

    it "loads the events page" do
      expect(page).to have_css("h1", text: "Events")
    end

    it "displays the event title" do
      expect(page).to have_css("td", text: "Smith & Jones Wedding")
    end

    it "has a Select link for the event" do
      expect(page).to have_link("Select", href: event_path(event))
    end
  end

  describe "GET /events/:id" do
    before { visit event_path(event) }

    it "loads the event show page" do
      expect(page).to have_css("h1", text: "Smith & Jones Wedding")
    end

    it "has an Edit Details link" do
      expect(page).to have_link("Edit Details", href: edit_event_path(event))
    end

    it "displays the event date" do
      expect(page).to have_text("June 15, 2026")
    end

    it "displays the theme" do
      expect(page).to have_text("Black Tie")
    end

    context "with no optional fields" do
      let!(:event) { create(:event, account: account, title: "Minimal Event", event_date: nil) }

      it "omits the date and theme lines" do
        visit event_path(event)

        expect(page).not_to have_text("Date:")
        expect(page).not_to have_text("Theme:")
      end
    end
  end

  describe "GET /events/:id/edit" do
    before { visit edit_event_path(event) }

    it "loads the edit event page" do
      expect(page).to have_css("h1", text: "Edit Event")
    end

    it "pre-fills the event fields" do
      expect(page).to have_field("event_title", with: "Smith & Jones Wedding")
      expect(page).to have_field("event_theme", with: "Black Tie")
    end

    it "has a Save Changes button" do
      expect(page).to have_button("Save Changes")
    end

    context "with valid data" do
      it "updates the event and redirects to event show" do
        fill_in "event_title", with: "Updated Wedding"
        click_button "Save Changes"

        expect(page).to have_current_path(event_path(event))
        expect(page).to have_css("h1", text: "Updated Wedding")
      end
    end

    context "with blank title" do
      it "re-renders with an error" do
        fill_in "event_title", with: ""
        click_button "Save Changes"

        expect(page).to have_css("h1", text: "Edit Event")
      end
    end
  end
end
