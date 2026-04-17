require "rails_helper"

RSpec.describe "Registrations", type: :system do
  describe "GET /users/sign_up" do
    before { visit new_user_registration_path }

    it "loads the sign-up page" do
      expect(page).to have_css("h1", text: "Create your account")
    end

    it "has Your Profile and Your Event subheadings" do
      expect(page).to have_css("h2", text: "Your Profile")
      expect(page).to have_css("h2", text: "Your Event")
    end

    it "has all profile fields" do
      expect(page).to have_field("user_first_name")
      expect(page).to have_field("user_last_name")
      expect(page).to have_field("user_email")
      expect(page).to have_field("user_password")
      expect(page).to have_field("user_password_confirmation")
    end

    it "has role radio buttons" do
      expect(page).to have_css("input[type='radio'][value='coordinator']")
      expect(page).to have_css("input[type='radio'][value='bride']")
      expect(page).to have_css("input[type='radio'][value='groom']")
    end

    it "has event fields" do
      expect(page).to have_field("event_title")
      expect(page).to have_field("event_event_date")
    end

    it "has a Sign Up button" do
      expect(page).to have_button("Sign Up")
    end

    it "has a Sign In link" do
      expect(page).to have_link("Sign In", href: new_user_session_path)
    end

    context "with valid data" do
      it "creates a user and redirects away from sign-up page" do
        fill_in "user_first_name", with: "Jane"
        fill_in "user_last_name", with: "Doe"
        fill_in "user_email", with: "jane.doe@example.com"
        fill_in "user_password", with: "password123"
        fill_in "user_password_confirmation", with: "password123"
        choose "Coordinator"
        fill_in "event_title", with: "Doe & Smith Wedding"
        click_button "Sign Up"

        expect(page).not_to have_current_path(new_user_registration_path)
      end
    end
  end
end
