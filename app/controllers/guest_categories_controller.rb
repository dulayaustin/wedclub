class GuestCategoriesController < ApplicationController
  def index
    render Views::GuestCategories::Index.new(guest_categories: GuestCategory.all)
  end

  def new
    render Views::GuestCategories::New.new(guest_category: GuestCategory.new)
  end

  def create
    guest_category = GuestCategory.new(guest_category_params)
    if guest_category.save
      redirect_to guest_categories_path
    else
      render Views::GuestCategories::New.new(guest_category: guest_category), status: :unprocessable_entity
    end
  end

  def edit
    guest_category = GuestCategory.find(params[:id])
    render Views::GuestCategories::Edit.new(guest_category: guest_category)
  end

  def update
    guest_category = GuestCategory.find(params[:id])
    if guest_category.update(guest_category_params)
      redirect_to guest_categories_path
    else
      render Views::GuestCategories::Edit.new(guest_category: guest_category), status: :unprocessable_entity
    end
  end

  def destroy
    GuestCategory.find(params[:id]).destroy
    redirect_to guest_categories_path
  end

  private

  def guest_category_params
    params.require(:guest_category).permit(:name)
  end
end
