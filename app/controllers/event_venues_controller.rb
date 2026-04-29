class EventVenuesController < ApplicationController
  before_action :require_account
  before_action :require_event
  before_action :set_event_venue, only: [ :edit, :update, :destroy ]

  def index
    render Views::EventVenues::Index.new(event_venues: current_event.event_venues.includes(:venue).order(:role))
  end

  def new
    render Views::EventVenues::New.new(
      event_venue: EventVenue.new,
      venues: Venue.order(:name),
      available_roles: available_roles
    )
  end

  def create
    event_venue = current_event.event_venues.new(event_venue_params)

    if event_venue.venue_id.blank? && params[:venue].present?
      venue = Venue.new(venue_params)
      if venue.save
        event_venue.venue_id = venue.id
      else
        render Views::EventVenues::New.new(
          event_venue: event_venue,
          venues: Venue.order(:name),
          available_roles: available_roles
        ), status: :unprocessable_entity
        return
      end
    end

    if event_venue.save
      redirect_to event_venues_path
    else
      render Views::EventVenues::New.new(
        event_venue: event_venue,
        venues: Venue.order(:name),
        available_roles: available_roles
      ), status: :unprocessable_entity
    end
  end

  def edit
    render Views::EventVenues::Edit.new(
      event_venue: @event_venue,
      venues: Venue.order(:name),
      available_roles: available_roles_for_edit
    )
  end

  def update
    if @event_venue.update(event_venue_params)
      redirect_to event_venues_path, notice: "Venue assignment updated."
    else
      render Views::EventVenues::Edit.new(
        event_venue: @event_venue,
        venues: Venue.order(:name),
        available_roles: available_roles_for_edit
      ), status: :unprocessable_entity
    end
  end

  def destroy
    @event_venue.destroy
    redirect_to event_venues_path, notice: "Venue assignment removed."
  end

  private

  def set_event_venue
    @event_venue = current_event.event_venues.find_by(id: params[:id])
    redirect_to event_venues_path, alert: "Venue assignment not found." unless @event_venue
  end

  def event_venue_params
    permitted = params.expect(event_venue: [ :venue_id, :role, :start_at, :end_at, :notes ])
    venue_id = permitted[:venue_id]
    permitted.delete(:venue_id) if venue_id.present? && !Venue.exists?(venue_id.to_i)
    permitted
  end

  def venue_params
    params.expect(venue: [ :name, :venue_type, :address_line1, :address_line2, :city, :state, :country, :phone_number, :website ])
  end

  def available_roles
    taken = current_event.event_venues.pluck(:role)
    EventVenue.roles.keys.reject { |r| taken.include?(r) }
  end

  def available_roles_for_edit
    taken = current_event.event_venues.where.not(id: @event_venue.id).pluck(:role)
    EventVenue.roles.keys.reject { |r| taken.include?(r) }
  end
end
