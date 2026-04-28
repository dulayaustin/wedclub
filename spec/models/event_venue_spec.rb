require "rails_helper"

RSpec.describe EventVenue, type: :model do
  describe "associations" do
    it { should belong_to(:event) }
    it { should belong_to(:venue) }
  end

  describe "enums" do
    it { should define_enum_for(:role).with_values({ ceremony: 0, reception: 1 }).with_prefix }
  end

  describe "validations" do
    subject { create(:event_venue) }

    it { should validate_presence_of(:role) }

    it "enforces uniqueness of role scoped to event" do
      event = create(:event)
      venue1 = create(:venue)
      venue2 = create(:venue)
      create(:event_venue, event: event, venue: venue1, role: :ceremony)
      duplicate = build(:event_venue, event: event, venue: venue2, role: :ceremony)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:role]).to be_present
    end

    context "when end_at is before start_at" do
      it "is invalid" do
        event_venue = build(:event_venue, start_at: 1.hour.from_now, end_at: 30.minutes.from_now)
        expect(event_venue).not_to be_valid
        expect(event_venue.errors[:end_at]).to include("must be after start time")
      end
    end

    context "when end_at is after start_at" do
      it "is valid" do
        event_venue = create(:event_venue, start_at: 1.hour.from_now, end_at: 2.hours.from_now)
        expect(event_venue).to be_valid
      end
    end

    context "when start_at and end_at are both blank" do
      it "is valid" do
        event_venue = create(:event_venue, start_at: nil, end_at: nil)
        expect(event_venue).to be_valid
      end
    end
  end
end
