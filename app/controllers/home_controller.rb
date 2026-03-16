class HomeController < ApplicationController
  def index
    render Views::Home::Index.new(account: Account.new)
  end
end
