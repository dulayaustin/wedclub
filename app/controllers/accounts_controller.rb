class AccountsController < ApplicationController
  before_action :set_account, only: %i[show edit update destroy]

  def index
    render Views::Accounts::Index.new(accounts: Account.all)
  end

  def show
    render Views::Accounts::Show.new(account: @account)
  end

  def new
    render Views::Accounts::New.new(account: Account.new)
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      redirect_to accounts_path
    else
      render Views::Accounts::New.new(account: @account), status: :unprocessable_entity
    end
  end

  def edit
    render Views::Accounts::Edit.new(account: @account)
  end

  def update
    if @account.update(account_params)
      redirect_to accounts_path
    else
      render Views::Accounts::Edit.new(account: @account), status: :unprocessable_entity
    end
  end

  def destroy
    @account.destroy
    redirect_to accounts_path
  end

  private

  def set_account
    @account = Account.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:name)
  end
end
