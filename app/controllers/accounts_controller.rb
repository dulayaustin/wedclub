class AccountsController < ApplicationController
  before_action :set_account, only: %i[show edit update destroy]

  def index
    render Views::Accounts::Index.new(accounts: current_user.accounts)
  end

  def show
    render Views::Accounts::Show.new(account: @account)
  end

  def new
    render Views::Accounts::New.new(account: Account.new)
  end

  def create
    result = Accounts::Create.new(user: current_user, params: account_params).call
    if result.success?
      set_account_session(result.account)
      redirect_to guests_path
    else
      render Views::Accounts::New.new(account: result.account), status: :unprocessable_entity
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
    @account = current_user.accounts.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:name)
  end
end
