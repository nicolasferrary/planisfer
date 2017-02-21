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

ActiveRecord::Schema.define(version: 20170221141049) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "airports", force: :cascade do |t|
    t.string   "name"
    t.string   "iata"
    t.integer  "city_id"
    t.integer  "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_airports_on_city_id", using: :btree
    t.index ["region_id"], name: "index_airports_on_region_id", using: :btree
  end

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.string   "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "regions", force: :cascade do |t|
    t.string   "name"
    t.string   "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "round_trip_flights", force: :cascade do |t|
    t.float    "price"
    t.string   "flight1_origin_airport_iata"
    t.string   "flight1_destination_airport_iata"
    t.string   "flight2_origin_airport_iata"
    t.string   "flight2_destination_airport_iata"
    t.datetime "flight1_landing_at"
    t.datetime "flight1_take_off_at"
    t.datetime "flight2_take_off_at"
    t.datetime "flight2_landing_at"
    t.integer  "trip_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["trip_id"], name: "index_round_trip_flights_on_trip_id", using: :btree
  end

  create_table "trips", force: :cascade do |t|
    t.float    "price"
    t.date     "starts_on"
    t.date     "returns_on"
    t.integer  "nb_travelers"
    t.integer  "city_id"
    t.integer  "region_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["city_id"], name: "index_trips_on_city_id", using: :btree
    t.index ["region_id"], name: "index_trips_on_region_id", using: :btree
  end

  add_foreign_key "airports", "cities"
  add_foreign_key "airports", "regions"
  add_foreign_key "round_trip_flights", "trips"
  add_foreign_key "trips", "cities"
  add_foreign_key "trips", "regions"
end
