class GuestsController < ApplicationController
  def index
    render Views::Guests::Index.new(guests: Guest.includes(:guest_category).all)
  end

  def new
    render Views::Guests::New.new(guest: Guest.new, categories: GuestCategory.all)
  end

  def create
    guest = Guest.new(guest_params)
    category_id = params.dig(:guest, :guest_category_id).presence
    guest.build_guest_guest_category(guest_category_id: category_id) if category_id
    if guest.save
      redirect_to guests_path
    else
      render Views::Guests::New.new(guest: guest, categories: GuestCategory.all), status: :unprocessable_entity
    end
  end

  private

  def guest_params
    params.require(:guest).permit(:first_name, :last_name)
  end
end
