# Plan: Updated Account Creation & Event Flow

## Context

The current signup flow is fragmented: user signs up, then separately creates an account, then navigates to guests. The new flow consolidates everything into one signup form (User + Account + Event), sets the account in session immediately, and redirects to an event details page. From there users can edit event details (name, date, venue, theme), manage guests, and configure guest categories.

There is also an existing bug: `GuestsController` and `GuestCategoriesController` call `current_account.guest_categories` but `Account` model lacks that association — this gets fixed as part of the event-scoping refactor.

---

## Implementation Steps

### 1. Database Migration

Create: `db/migrate/TIMESTAMP_add_venue_and_theme_to_events.rb`

```ruby
class AddVenueAndThemeToEvents < ActiveRecord::Migration[8.1]
  def change
    add_column :events, :venue, :string
    add_column :events, :theme, :string
  end
end
```

Run: `bundle exec rails db:migrate`

---

### 2. Model Change — `app/models/account.rb`

Add the missing through association (fixes the crash, and makes the model semantically complete):

```ruby
has_many :guest_categories, through: :events
```

---

### 3. New Service — `app/services/registrations/create.rb`

Atomic transaction creating User + Account + AccountUser + Event in one shot. Stores built objects in instance variables so errors are accessible for re-render on failure.

```ruby
module Registrations
  class Create
    Result = Data.define(:success, :user, :account, :event) do
      def success? = success
    end

    def initialize(user_params:, account_params:, event_params:)
      @user_params    = user_params
      @account_params = account_params
      @event_params   = event_params
      @built_user     = User.new
      @built_account  = Account.new
      @built_event    = Event.new
    end

    def call
      ActiveRecord::Base.transaction do
        @built_user = User.new(@user_params)
        raise ActiveRecord::Rollback unless @built_user.save

        @built_account = Account.new(@account_params)
        raise ActiveRecord::Rollback unless @built_account.save

        @built_account.account_users.create!(user: @built_user)

        @built_event = @built_account.events.new(@event_params)
        raise ActiveRecord::Rollback unless @built_event.save

        return Result.new(success: true, user: @built_user, account: @built_account, event: @built_event)
      end

      Result.new(success: false, user: @built_user, account: @built_account, event: @built_event)
    end
  end
end
```

Keep `app/services/accounts/create.rb` unchanged (still used by `AccountsController`).

---

### 4. Extend `app/controllers/concerns/account_sessionable.rb`

Add event session methods alongside existing account methods:

```ruby
def set_event_session(event)
  session[:event_id] = event.id
end

def clear_event_session
  session.delete(:event_id)
end

def current_event
  @current_event ||= current_account&.events&.find_by(id: session[:event_id])
end

def require_event
  return if current_event
  if current_account&.events&.any?
    set_event_session(current_account.events.first)
    redirect_to event_path(current_account.events.first)
  else
    redirect_to accounts_path, alert: "Please set up an event first."
  end
end
```

`current_event` scopes through `current_account.events` — prevents IDOR (user can't access another account's event by tampering with session).

---

### 5. Update `app/controllers/application_controller.rb`

- Add `helper_method :current_event`
- Update `after_sign_in_path_for` to redirect returning users to their event page:

```ruby
helper_method :current_account, :current_event

def after_sign_in_path_for(_resource)
  if current_account&.events&.any?
    event = current_account.events.first
    set_event_session(event)
    event_path(event)
  else
    accounts_path
  end
end
```

---

### 6. Rewrite `app/controllers/users/registrations_controller.rb`

```ruby
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  def new
    self.resource = resource_class.new
    render Views::Users::Registrations::New.new(
      user: self.resource, account: Account.new, event: Event.new
    )
  end

  def create
    result = Registrations::Create.new(
      user_params:    sign_up_params,
      account_params: account_params,
      event_params:   event_params
    ).call

    if result.success?
      self.resource = result.user
      sign_up(resource_name, result.user)
      set_account_session(result.account)
      set_event_session(result.event)
      redirect_to event_path(result.event), notice: "Welcome! Your event is ready."
    else
      self.resource = result.user
      render Views::Users::Registrations::New.new(
        user: result.user, account: result.account, event: result.event
      ), status: :unprocessable_entity
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end

  private

  def account_params
    # Account name mirrors the event name — single input drives both
    { name: params.dig(:event, :name) }
  end

  def event_params
    params.require(:event).permit(:name, :event_date)
  end
end
```

---

### 7. Create `app/controllers/events_controller.rb`

```ruby
class EventsController < ApplicationController
  before_action :require_account
  before_action :set_event

  def show
    render Views::Events::Show.new(event: @event)
  end

  def edit
    render Views::Events::Edit.new(event: @event)
  end

  def update
    if @event.update(event_params)
      redirect_to event_path(@event), notice: "Event updated."
    else
      render Views::Events::Edit.new(event: @event), status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = current_account.events.find(params[:id])
    set_event_session(@event)
  end

  def event_params
    params.require(:event).permit(:name, :event_date, :venue, :theme)
  end
end
```

---

### 8. Refactor `app/controllers/guests_controller.rb`

Replace `require_account` + `current_account.guests` with `require_event` + `current_event.guests`:

- Add `before_action :require_event`
- `index`: `current_event.guests`
- `new`: pass `categories: current_event.guest_categories`
- `create`: `current_event.guests.new(guest_params)` (sets `event_id` automatically)
- `guest_params`: scope category validation to `current_event.guest_categories`

---

### 9. Refactor `app/controllers/guest_categories_controller.rb`

Replace all `current_account.guest_categories` with `current_event.guest_categories`:

- Add `before_action :require_event`
- All queries go through `current_event.guest_categories`
- `set_guest_category`: scope to `current_event.guest_categories.find_by(id: params[:id])`

---

### 10. Update `app/controllers/account_sessions_controller.rb`

On account switch, clear stale event session and set the new account's event:

```ruby
def create
  account = current_user.accounts.find(params[:account_id])
  set_account_session(account)
  clear_event_session
  if account.events.any?
    event = account.events.first
    set_event_session(event)
    redirect_to event_path(event)
  else
    redirect_to accounts_path
  end
end

def destroy
  clear_account_session
  clear_event_session
  redirect_to accounts_path
end
```

---

### 11. Add `resources :events` to `config/routes.rb`

```ruby
resources :events, only: [:show, :edit, :update]
```

---

### 12. Rewrite `app/views/users/registrations/new.rb`

Two-section form posting to `user_registration_path`:

- **Section 1 — Your profile**: `first_name`, `last_name`, `email`, `password`, `password_confirmation` (params: `user[...]`)
- **Section 2 — Your event**: a single `name` field (e.g. "Smith & Jones Wedding") used for both `account[name]` and `event[name]` — one visible input, two hidden inputs or controller-level duplication. Also includes `event_date` (optional, params: `event[event_date]`).

The controller (or service) copies the submitted name into both `account_params` and `event_params` so the user only fills it in once.

Show per-field errors from `@user.errors`, `@account.errors`, `@event.errors`.

Constructor: `initialize(user:, account:, event:)`

---

### 13. Create `app/views/events/show.rb`

Display event details (name, date, venue, theme) with an "Edit Details" link and navigation buttons to "Manage Guests" (`guests_path`) and "Guest Categories" (`guest_categories_path`).

Constructor: `initialize(event:)`

---

### 14. Create `app/views/events/edit.rb`

Form with fields: `name` (required), `event_date` (date input), `venue`, `theme`. Posts PATCH to `event_path(@event)`. Shows per-field validation errors.

Constructor: `initialize(event:)`

---

## Files to Create or Modify

| Action | File |
|--------|------|
| CREATE | `db/migrate/TIMESTAMP_add_venue_and_theme_to_events.rb` |
| MODIFY | `app/models/account.rb` |
| CREATE | `app/services/registrations/create.rb` |
| MODIFY | `app/controllers/concerns/account_sessionable.rb` |
| MODIFY | `app/controllers/application_controller.rb` |
| MODIFY | `app/controllers/users/registrations_controller.rb` |
| CREATE | `app/controllers/events_controller.rb` |
| MODIFY | `app/controllers/guests_controller.rb` |
| MODIFY | `app/controllers/guest_categories_controller.rb` |
| MODIFY | `app/controllers/account_sessions_controller.rb` |
| MODIFY | `config/routes.rb` |
| MODIFY | `app/views/users/registrations/new.rb` |
| CREATE | `app/views/events/show.rb` |
| CREATE | `app/views/events/edit.rb` |

---

## Tests to Add / Update

**New specs:**
- `spec/services/registrations/create_spec.rb` — valid flow, each failure case (invalid user/account/event), atomicity
- `spec/requests/events_spec.rb` — show, edit, update (authorized + unauthorized)
- `spec/requests/users/registrations_spec.rb` — GET sign_up, POST with valid/invalid params

**Update existing specs:**
- `spec/models/account_spec.rb` — add `have_many(:guest_categories).through(:events)`
- `spec/models/event_spec.rb` — add `respond_to(:venue)` and `respond_to(:theme)`

---

## Verification

1. `bundle exec rails db:migrate` — confirms migration runs cleanly
2. `bundle exec rspec` — all specs pass
3. Manual flow: sign up → confirm redirect to `/events/:id` show page → edit event details → navigate to guests → navigate to guest categories
4. Confirm account is in session (account name shows in nav) after signup
5. Confirm returning user login redirects to event page (not accounts page)
