# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_04_28_135803) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "account_users", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["account_id", "user_id"], name: "index_account_users_on_account_id_and_user_id", unique: true
    t.index ["account_id"], name: "index_account_users_on_account_id"
    t.index ["user_id"], name: "index_account_users_on_user_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_venues", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "end_at"
    t.bigint "event_id", null: false
    t.text "notes"
    t.integer "role", null: false
    t.datetime "start_at"
    t.datetime "updated_at", null: false
    t.bigint "venue_id", null: false
    t.index ["event_id", "role"], name: "index_event_venues_on_event_id_and_role", unique: true
    t.index ["event_id"], name: "index_event_venues_on_event_id"
    t.index ["venue_id"], name: "index_event_venues_on_venue_id"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "event_date"
    t.string "theme"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_events_on_account_id"
  end

  create_table "guest_categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "event_id", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_guest_categories_on_event_id"
  end

  create_table "guests", force: :cascade do |t|
    t.integer "age_group"
    t.datetime "created_at", null: false
    t.bigint "event_id", null: false
    t.string "first_name", null: false
    t.bigint "guest_category_id"
    t.integer "guest_of"
    t.string "last_name", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_guests_on_event_id"
    t.index ["guest_category_id"], name: "index_guests_on_guest_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "venues", force: :cascade do |t|
    t.text "address_line1"
    t.text "address_line2"
    t.string "city"
    t.string "country"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.text "notes"
    t.string "phone_number"
    t.string "state"
    t.datetime "updated_at", null: false
    t.integer "venue_type", null: false
    t.string "website"
    t.index ["name"], name: "index_venues_on_name"
  end

  add_foreign_key "account_users", "accounts"
  add_foreign_key "account_users", "users"
  add_foreign_key "event_venues", "events"
  add_foreign_key "event_venues", "venues"
  add_foreign_key "events", "accounts"
  add_foreign_key "guest_categories", "events"
  add_foreign_key "guests", "events"
end
