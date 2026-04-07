class GuestCategoriesController < ApplicationController
  before_action :require_account
  before_action :require_event
  before_action :set_guest_category, only: [ :edit, :update, :destroy ]

  def index
    render Views::GuestCategories::Index.new(guest_categories: current_event.guest_categories)
  end

  def new
    render Views::GuestCategories::New.new(guest_category: GuestCategory.new)
  end

  def create
    guest_category = current_event.guest_categories.new(guest_category_params)
    if guest_category.save
      redirect_to guest_categories_path
    else
      render Views::GuestCategories::New.new(guest_category: guest_category), status: :unprocessable_entity
    end
  end

  def edit
    render Views::GuestCategories::Edit.new(guest_category: @guest_category)
  end

  def update
    if @guest_category.update(guest_category_params)
      redirect_to guest_categories_path
    else
      render Views::GuestCategories::Edit.new(guest_category: @guest_category), status: :unprocessable_entity
    end
  end

  def destroy
    @guest_category.destroy
    redirect_to guest_categories_path
  end

  private

  def guest_category_params
    params.require(:guest_category).permit(:name)
  end

  def set_guest_category
    @guest_category = current_event.guest_categories.find_by(id: params[:id])
    redirect_to home_path, alert: "Guest category cannot be found" unless @guest_category.present?
  end
end
