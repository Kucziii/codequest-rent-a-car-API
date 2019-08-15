# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_08_11_154117) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cars", id: :serial, force: :cascade do |t|
    t.string "model"
    t.string "make"
    t.string "year"
    t.integer "mileage"
    t.string "condition"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "office_id"
  end

  create_table "offices", id: :serial, force: :cascade do |t|
    t.string "street"
    t.string "postal_code"
    t.string "city"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "owner_id"
  end

  create_table "rentals", force: :cascade do |t|
    t.bigint "customer_id"
    t.bigint "car_id"
    t.string "car_make"
    t.string "car_model"
    t.datetime "rented_from"
    t.datetime "rented_to"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "street"
    t.string "city"
    t.string "postal_code"
    t.string "phone_number"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.bigint "office_id"
  end

end
