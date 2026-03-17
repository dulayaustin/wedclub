class GuestsController < ApplicationController
  before_action :require_account

  def index
    render Views::Guests::Index.new(guests: current_account.guests)
  end

  def new
    render Views::Guests::New.new(guest: Guest.new, categories: current_account.account_guest_categories)
  end

  def create
    guest = Guest.new(guest_params)
    category_id = params.dig(:guest, :account_guest_category_id).presence
    guest.build_guest_category(account_guest_category_id: category_id) if category_id
    if guest.save
      redirect_to guests_path
    else
      render Views::Guests::New.new(guest: guest, categories: current_account.account_guest_categories), status: :unprocessable_entity
    end
  end

  private

  def guest_params
    params.require(:guest).permit(:first_name, :last_name, :age_group, :guest_of)
  end
end
