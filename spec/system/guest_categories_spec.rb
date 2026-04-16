require "rails_helper"

RSpec.describe "Guest Categories", type: :system do
  let(:user) { create(:user) }
  let!(:account) { create(:account).tap { |a| a.account_users.create!(user: user) } }
  let!(:event) { create(:event, account: account) }
  # Event auto-creates "Family", "Friends", "Workmates" via after_create callback
  let(:category) { event.guest_categories.find_by!(name: "Family") }

  before do
    sign_in_as(user)
    select_account(account) # redirects to event show, setting event session
  end

  describe "GET /guest_categories" do
    before { visit guest_categories_path }

    it "loads the guest categories page" do
      expect(page).to have_css("h1", text: "Guest Categories")
    end

    it "has an Add Category link" do
      expect(page).to have_link("Add Category", href: new_guest_category_path)
    end

    it "displays the default category names" do
      expect(page).to have_css("td", text: "Family")
      expect(page).to have_css("td", text: "Friends")
    end

    it "has Edit and Delete actions" do
      expect(page).to have_link("Edit")
      expect(page).to have_button("Delete")
    end

    context "when deleting a category" do
      it "removes the category and redirects to categories index" do
        within("tr", text: "Family") do
          click_button "Delete"
        end

        expect(page).to have_current_path(guest_categories_path)
        expect(page).not_to have_css("td", text: "Family")
      end
    end

    context "with no categories" do
      before do
        event.guest_categories.destroy_all
        visit guest_categories_path
      end

      it "shows the empty state message" do
        expect(page).to have_text("No categories yet. Add your first category!")
      end
    end
  end

  describe "GET /guest_categories/new" do
    before { visit new_guest_category_path }

    it "loads the add category page" do
      expect(page).to have_css("h1", text: "Add Category")
    end

    it "has a Name field and Add Category button" do
      expect(page).to have_field("guest_category_name")
      expect(page).to have_button("Add Category")
    end

    context "with valid data" do
      it "creates a category and redirects to categories index" do
        fill_in "guest_category_name", with: "VIP"
        click_button "Add Category"

        expect(page).to have_current_path(guest_categories_path)
        expect(page).to have_css("td", text: "VIP")
      end
    end

    context "with blank name" do
      it "re-renders with an error" do
        fill_in "guest_category_name", with: ""
        click_button "Add Category"

        expect(page).to have_css("h1", text: "Add Category")
      end
    end
  end

  describe "GET /guest_categories/:id/edit" do
    before { visit edit_guest_category_path(category) }

    it "loads the edit category page" do
      expect(page).to have_css("h1", text: "Edit Category")
    end

    it "pre-fills the Name field" do
      expect(page).to have_field("guest_category_name", with: "Family")
    end

    it "has an Update Category button" do
      expect(page).to have_button("Update Category")
    end

    context "with valid data" do
      it "updates the category and redirects to categories index" do
        fill_in "guest_category_name", with: "Close Family"
        click_button "Update Category"

        expect(page).to have_current_path(guest_categories_path)
        expect(page).to have_css("td", text: "Close Family")
      end
    end

    context "with blank name" do
      it "re-renders with an error" do
        fill_in "guest_category_name", with: ""
        click_button "Update Category"

        expect(page).to have_css("h1", text: "Edit Category")
      end
    end
  end
end
