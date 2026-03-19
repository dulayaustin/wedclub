class AccountGuestCategoriesController < ApplicationController
  before_action :require_account
  before_action :set_account_guest_category, only: [ :edit, :update, :destroy ]

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
    render Views::AccountGuestCategories::Edit.new(account_guest_category: @account_guest_category)
  end

  def update
    if @account_guest_category.update(account_guest_category_params)
      redirect_to account_guest_categories_path
    else
      render Views::AccountGuestCategories::Edit.new(account_guest_category: @account_guest_category), status: :unprocessable_entity
    end
  end

  def destroy
    @account_guest_category.destroy
    redirect_to account_guest_categories_path
  end

  private

  def account_guest_category_params
    params.require(:account_guest_category).permit(:name)
  end

  def set_account_guest_category
    @account_guest_category = current_account.account_guest_categories.find_by(id: params[:id])
    redirect_to home_path unless @account_guest_category.present?
  end
end
