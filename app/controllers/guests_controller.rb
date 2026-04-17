class GuestsController < ApplicationController
  before_action :require_account
  before_action :require_event
  before_action :set_guest, only: [ :edit, :update, :destroy ]

  def index
    render Views::Guests::Index.new(guests: current_event.guests)
  end

  def new
    render Views::Guests::New.new(guest: Guest.new, categories: current_event.guest_categories)
  end

  def create
    guest = current_event.guests.new(guest_params)
    if guest.save
      redirect_to guests_path
    else
      render Views::Guests::New.new(guest: guest, categories: current_event.guest_categories), status: :unprocessable_entity
    end
  end

  def edit
    render Views::Guests::Edit.new(guest: @guest, categories: current_event.guest_categories)
  end

  def update
    if @guest.update(guest_params)
      redirect_to guests_path, notice: "Guest updated."
    else
      render Views::Guests::Edit.new(guest: @guest, categories: current_event.guest_categories), status: :unprocessable_entity
    end
  end

  def destroy
    @guest.destroy
    redirect_to guests_path, notice: "Guest deleted."
  end

  private

  def set_guest
    @guest = current_event.guests.find_by(id: params[:id])
    redirect_to guests_path, alert: "Guest not found." unless @guest
  end

  def guest_params
    permitted = params.expect(guest: [ :first_name, :last_name, :age_group, :guest_of, :guest_category_id ])
    cat_id = permitted[:guest_category_id]
    permitted.delete(:guest_category_id) if cat_id.present? && !current_event.guest_categories.exists?(cat_id.to_i)
    permitted
  end
end
