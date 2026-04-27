require 'rails_helper'

RSpec.describe "Events", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let(:account) { create(:account) }
  let(:event) { create(:event, account: account) }

  before do
    account.account_users.create!(user: user)
    sign_in user
    post account_session_path, params: { account_id: account.id }
  end

  describe "GET /events" do
    it "returns http success" do
      get events_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /events/:id" do
    it "returns http success for owned event" do
      get event_path(event)
      expect(response).to have_http_status(:success)
    end

    it "returns 404 for event belonging to another account" do
      other_event = create(:event)
      get event_path(other_event)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /events/:id/edit" do
    it "returns http success for owned event" do
      get edit_event_path(event)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /events/:id" do
    it "updates the event and redirects" do
      patch event_path(event),
        params: { event: { title: "Updated Name", theme: "Black Tie" } }
      expect(response).to redirect_to(event_path(event))
      expect(event.reload.title).to eq("Updated Name")
      expect(event.theme).to eq("Black Tie")
    end

    it "re-renders edit on invalid params" do
      patch event_path(event), params: { event: { title: "" } }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end
end
