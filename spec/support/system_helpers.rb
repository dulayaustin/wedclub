Warden.test_mode!

module SystemHelpers
  def sign_in_as(user)
    login_as(user, scope: :user)
  end

  # Clicks "Select" on the accounts index for the given account.
  # When the account has exactly one event, AccountSessionsController redirects
  # to event_path(event), which also sets the event session automatically.
  def select_account(account)
    visit accounts_path
    within("tr", text: account.name) do
      click_button "Select"
    end
  end
end

RSpec.configure do |config|
  config.include Warden::Test::Helpers, type: :system
  config.include SystemHelpers, type: :system
  config.after(:each, type: :system) { Warden.test_reset! }
end
