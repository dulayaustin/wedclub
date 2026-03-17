# Account Session (`current_account` helper)

## Context

The app supports multiple accounts (wedding organizers), each with their own guest list and categories. Currently there is no way to "select" an account — all controllers query globally. The goal is to let users pick an account and have it remembered in the session, exposing a `current_account` helper throughout the app for scoping.

---

## Implementation Plan

### 1. `current_account` helper in `ApplicationController`

Store the selected account ID in `session[:account_id]` and expose it as a helper method:

```ruby
# app/controllers/application_controller.rb
def current_account
  @current_account ||= Account.find_by(id: session[:account_id])
end
helper_method :current_account
```

### 2. `AccountSessionsController` (new file)

Handles selecting and deselecting an account:

```ruby
# app/controllers/account_sessions_controller.rb
class AccountSessionsController < ApplicationController
  def create
    account = Account.find(params[:account_id])
    session[:account_id] = account.id
    redirect_to guests_path
  end

  def destroy
    session.delete(:account_id)
    redirect_to accounts_path
  end
end
```

### 3. Routes

```ruby
# config/routes.rb
resource :account_session, only: [:create, :destroy]
```

This gives:
- `POST /account_session` → `AccountSessionsController#create`
- `DELETE /account_session` → `AccountSessionsController#destroy`

### 4. Accounts index view — "Select" button per row

In `app/views/accounts/index.rb`, add a form per account row that POSTs to `account_session_path` with `account_id`. Highlight the currently selected account row visually.

### 5. Current account in the navbar

In Phlex views, Rails helper methods are accessible via `helpers`. Display the current account name and a "Switch Account" link in the navbar when an account is selected.

### 6. Scope controllers to `current_account`

`GuestsController` and `AccountGuestCategoriesController` should filter data by the selected account. For `new`/`create` actions, only show categories belonging to `current_account`.

### 7. Guard: `require_account` before action

Add a `before_action :require_account` to `GuestsController` (and `AccountGuestCategoriesController`) that redirects to `accounts_path` if no account is selected.

---

## Files Changed

| File | Change |
|------|--------|
| `app/controllers/application_controller.rb` | Add `current_account` helper method |
| `app/controllers/guests_controller.rb` | Scope to `current_account`, add `require_account` |
| `app/controllers/account_guest_categories_controller.rb` | Scope to `current_account`, add `require_account` |
| `config/routes.rb` | Add `resource :account_session` |
| `app/views/accounts/index.rb` | Add "Select" button per row, highlight active |
| `app/views/home/index.rb` | Show current account in nav + switch link |

## New Files

| File | Purpose |
|------|---------|
| `app/controllers/account_sessions_controller.rb` | Create/destroy account session |

---

## Verification

1. Start the server: `bin/dev`
2. Go to `/accounts` — see accounts list with a "Select" button
3. Click "Select" → session is stored, redirected to `/guests`
4. Navbar shows the account name and a "Switch Account" link
5. `/guests` only shows guests for the selected account
6. Clicking "Switch Account" clears the session and returns to `/accounts`
7. Accessing `/guests` without a selected account redirects to `/accounts`
8. Run `bundle exec rspec` — existing tests pass
