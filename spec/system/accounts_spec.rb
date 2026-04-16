require "rails_helper"

RSpec.describe "Accounts", type: :system do
  let(:user) { create(:user) }
  let!(:account) { create(:account, name: "Wedding Co").tap { |a| a.account_users.create!(user: user) } }

  before { sign_in_as(user) }

  describe "GET /accounts" do
    before { visit accounts_path }

    it "loads the accounts page" do
      expect(page).to have_css("h1", text: "Accounts")
    end

    it "has a New Account link" do
      expect(page).to have_link("New Account", href: new_account_path)
    end

    it "displays the account name" do
      expect(page).to have_css("td", text: "Wedding Co")
    end

    it "has Edit and Delete actions" do
      expect(page).to have_link("Edit")
      expect(page).to have_button("Delete")
    end

    it "shows a Select button when account is not active" do
      expect(page).to have_button("Select")
    end

    context "when clicking Select" do
      it "sets the account session and shows the Selected badge" do
        click_button "Select"

        visit accounts_path
        expect(page).to have_css("td", text: "Selected")
        expect(page).not_to have_button("Select")
      end
    end
  end

  describe "GET /accounts/new" do
    before { visit new_account_path }

    it "loads the new account page" do
      expect(page).to have_css("h1", text: "New Account")
    end

    it "has a Name field and Create Account button" do
      expect(page).to have_field("account_name")
      expect(page).to have_button("Create Account")
    end

    context "with valid data" do
      it "creates an account and redirects" do
        fill_in "account_name", with: "New Wedding Account"
        click_button "Create Account"

        # New account has no events, so guests_path redirects to accounts_path
        expect(page).to have_current_path(accounts_path)
      end
    end

    context "with blank name" do
      it "re-renders with an error" do
        fill_in "account_name", with: ""
        click_button "Create Account"

        expect(page).to have_css("h1", text: "New Account")
      end
    end
  end

  describe "GET /accounts/:id/edit" do
    before { visit edit_account_path(account) }

    it "loads the edit account page" do
      expect(page).to have_css("h1", text: "Edit Account")
    end

    it "pre-fills the Name field" do
      expect(page).to have_field("account_name", with: "Wedding Co")
    end

    it "has an Update Account button" do
      expect(page).to have_button("Update Account")
    end

    context "with valid data" do
      it "updates the account and redirects to accounts index" do
        fill_in "account_name", with: "Renamed Wedding Co"
        click_button "Update Account"

        expect(page).to have_current_path(accounts_path)
        expect(page).to have_css("td", text: "Renamed Wedding Co")
      end
    end

    context "with blank name" do
      it "re-renders with an error" do
        fill_in "account_name", with: ""
        click_button "Update Account"

        expect(page).to have_css("h1", text: "Edit Account")
      end
    end
  end
end
