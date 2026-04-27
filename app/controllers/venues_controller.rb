class VenuesController < ApplicationController
  before_action :set_venue, only: [ :show, :edit, :update, :destroy ]

  def index
    render Views::Venues::Index.new(venues: Venue.order(:name))
  end

  def show
    render Views::Venues::Show.new(venue: @venue)
  end

  def new
    render Views::Venues::New.new(venue: Venue.new)
  end

  def create
    venue = Venue.new(venue_params)
    if venue.save
      redirect_to venues_path, notice: "Venue added."
    else
      render Views::Venues::New.new(venue: venue), status: :unprocessable_entity
    end
  end

  def edit
    render Views::Venues::Edit.new(venue: @venue)
  end

  def update
    if @venue.update(venue_params)
      redirect_to venues_path, notice: "Venue updated."
    else
      render Views::Venues::Edit.new(venue: @venue), status: :unprocessable_entity
    end
  end

  def destroy
    @venue.destroy
    redirect_to venues_path, notice: "Venue deleted."
  end

  private

  def set_venue
    @venue = Venue.find_by(id: params[:id])
    redirect_to venues_path, alert: "Venue not found." unless @venue
  end

  def venue_params
    params.expect(venue: [ :name, :venue_type, :address_line1, :address_line2,
                           :city, :state, :country, :phone_number, :website, :notes ])
  end
end
