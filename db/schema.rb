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

ActiveRecord::Schema[8.1].define(version: 2026_03_13_151457) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "guest_categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_guest_categories_on_name", unique: true
  end

  create_table "guest_guest_categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "guest_category_id", null: false
    t.bigint "guest_id", null: false
    t.datetime "updated_at", null: false
    t.index ["guest_category_id"], name: "index_guest_guest_categories_on_guest_category_id"
    t.index ["guest_id", "guest_category_id"], name: "index_guest_guest_categories_on_guest_id_and_guest_category_id", unique: true
    t.index ["guest_id"], name: "index_guest_guest_categories_on_guest_id"
  end

  create_table "guests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "guest_guest_categories", "guest_categories"
  add_foreign_key "guest_guest_categories", "guests"
end
