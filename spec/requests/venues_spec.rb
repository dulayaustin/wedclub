require 'rails_helper'

RSpec.describe "Venues", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let!(:venue) { create(:venue, name: "The Grand Hall", venue_type: :hall) }

  before { sign_in user }

  describe "GET /venues" do
    it "returns http success" do
      get venues_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /venues/:id" do
    it "returns http success" do
      get venue_path(venue)
      expect(response).to have_http_status(:success)
    end

    it "returns 404 for a non-existent venue" do
      get venue_path(id: 0)
      expect(response).to redirect_to(venues_path)
    end
  end

  describe "GET /venues/new" do
    it "returns http success" do
      get new_venue_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /venues" do
    context "with valid params" do
      it "creates a venue and redirects to venues index" do
        expect {
          post venues_path, params: { venue: { name: "Beachside Chapel", venue_type: "church", city: "Malibu" } }
        }.to change(Venue, :count).by(1)

        expect(response).to redirect_to(venues_path)
      end
    end

    context "with invalid params" do
      it "re-renders new on missing name" do
        post venues_path, params: { venue: { name: "", venue_type: "beach" } }
        expect(response).to have_http_status(:unprocessable_content)
      end

      it "re-renders new on missing venue_type" do
        post venues_path, params: { venue: { name: "Some Place", venue_type: "" } }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "GET /venues/:id/edit" do
    it "returns http success" do
      get edit_venue_path(venue)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /venues/:id" do
    context "with valid params" do
      it "updates the venue and redirects to venues index" do
        patch venue_path(venue), params: { venue: { name: "Updated Hall", city: "New York" } }

        expect(response).to redirect_to(venues_path)
        expect(venue.reload.name).to eq("Updated Hall")
        expect(venue.city).to eq("New York")
      end
    end

    context "with invalid params" do
      it "re-renders edit on missing name" do
        patch venue_path(venue), params: { venue: { name: "" } }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "DELETE /venues/:id" do
    it "destroys the venue and redirects to venues index" do
      expect {
        delete venue_path(venue)
      }.to change(Venue, :count).by(-1)

      expect(response).to redirect_to(venues_path)
    end
  end

  describe "authentication" do
    before { sign_out user }

    it "redirects unauthenticated requests to sign in" do
      get venues_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
