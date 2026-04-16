require "rails_helper"

RSpec.describe "Sessions", type: :system do
  let(:user) { create(:user) }

  describe "GET /users/sign_in" do
    before { visit new_user_session_path }

    it "loads the sign-in page" do
      expect(page).to have_css("h1", text: "Sign In")
    end

    it "has email and password fields" do
      expect(page).to have_field("user_email")
      expect(page).to have_field("user_password")
    end

    it "has a Sign In button" do
      expect(page).to have_button("Sign In")
    end

    it "has a Sign Up link" do
      expect(page).to have_link("Sign Up", href: new_user_registration_path)
    end

    it "has a Forgot your password link" do
      expect(page).to have_link("Forgot your password?", href: new_user_password_path)
    end

    context "with valid credentials" do
      it "signs in and redirects away from sign-in page" do
        fill_in "user_email", with: user.email
        fill_in "user_password", with: "password123"
        click_button "Sign In"

        expect(page).not_to have_current_path(new_user_session_path)
      end
    end

    context "with invalid credentials" do
      it "re-renders the sign-in page with an error" do
        fill_in "user_email", with: user.email
        fill_in "user_password", with: "wrongpassword"
        click_button "Sign In"

        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end
end
