class AccountGuestCategoriesController < ApplicationController
  before_action :require_account

  def index
    render Views::AccountGuestCategories::Index.new(account_guest_categories: current_account.account_guest_categories)
  end

  def new
    render Views::AccountGuestCategories::New.new(account_guest_category: AccountGuestCategory.new)
  end

  def create
    account_guest_category = current_account.account_guest_categories.new(account_guest_category_params)
    if account_guest_category.save
      redirect_to account_guest_categories_path
    else
      render Views::AccountGuestCategories::New.new(account_guest_category: account_guest_category), status: :unprocessable_entity
    end
  end

  def edit
    account_guest_category = current_account.account_guest_categories.find(params[:id])
    render Views::AccountGuestCategories::Edit.new(account_guest_category: account_guest_category)
  end

  def update
    account_guest_category = current_account.account_guest_categories.find(params[:id])
    if account_guest_category.update(account_guest_category_params)
      redirect_to account_guest_categories_path
    else
      render Views::AccountGuestCategories::Edit.new(account_guest_category: account_guest_category), status: :unprocessable_entity
    end
  end

  def destroy
    current_account.account_guest_categories.find(params[:id]).destroy
    redirect_to account_guest_categories_path
  end

  private

  def account_guest_category_params
    params.require(:account_guest_category).permit(:name)
  end
end
