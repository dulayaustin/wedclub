require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  describe "GET /users/sign_up" do
    it "returns http success" do
      get new_user_registration_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /users" do
    let(:valid_params) do
      {
        user: {
          first_name: "Jane",
          last_name: "Smith",
          email: "jane@example.com",
          password: "password123",
          password_confirmation: "password123"
        },
        event: {
          name: "Smith & Jones Wedding",
          event_date: 1.year.from_now.to_date.to_s
        }
      }
    end

    context "with valid params" do
      it "creates user, account, and event" do
        expect {
          post user_registration_path, params: valid_params
        }.to change(User, :count).by(1)
          .and change(Account, :count).by(1)
          .and change(Event, :count).by(1)
      end

      it "redirects to the new event page" do
        post user_registration_path, params: valid_params
        event = Event.last
        expect(response).to redirect_to(event_path(event))
      end
    end

    context "with invalid user params" do
      it "returns unprocessable_entity" do
        post user_registration_path, params: valid_params.deep_merge(user: { email: "" })
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not create any records" do
        expect { post user_registration_path, params: valid_params.deep_merge(user: { email: "" }) }.not_to change(User, :count)
        expect { post user_registration_path, params: valid_params.deep_merge(user: { email: "" }) }.not_to change(Account, :count)
        expect { post user_registration_path, params: valid_params.deep_merge(user: { email: "" }) }.not_to change(Event, :count)
      end
    end

    context "with invalid event params" do
      it "returns unprocessable_entity" do
        post user_registration_path, params: valid_params.deep_merge(event: { name: "" })
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
