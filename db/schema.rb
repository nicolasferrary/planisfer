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

ActiveRecord::Schema.define(version: 20170228124440) do

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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "regions", force: :cascade do |t|
    t.string   "name"
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
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "currency"
    t.string   "carrier1"
    t.string   "carrier2"
    t.float    "latitude_arrive"
    t.float    "longitude_arrive"
    t.float    "latitude_back"
    t.float    "longitude_back"
  end

  create_table "searches", force: :cascade do |t|
    t.string   "city"
    t.string   "region"
    t.date     "starts_on"
    t.date     "returns_on"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "nb_travelers"
    t.string   "flight1_range"
    t.string   "flight2_range"
  end

  create_table "trips", force: :cascade do |t|
    t.float    "price"
    t.date     "starts_on"
    t.date     "returns_on"
    t.integer  "nb_travelers"
    t.integer  "city_id"
    t.integer  "region_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "round_trip_flight_id"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "search_id"
    t.index ["city_id"], name: "index_trips_on_city_id", using: :btree
    t.index ["region_id"], name: "index_trips_on_region_id", using: :btree
    t.index ["round_trip_flight_id"], name: "index_trips_on_round_trip_flight_id", using: :btree
    t.index ["search_id"], name: "index_trips_on_search_id", using: :btree
  end

  add_foreign_key "airports", "cities"
  add_foreign_key "airports", "regions"
  add_foreign_key "trips", "cities"
  add_foreign_key "trips", "regions"
  add_foreign_key "trips", "round_trip_flights"
  add_foreign_key "trips", "searches"
end
