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

ActiveRecord::Schema.define(version: 20170509105617) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "airports", force: :cascade do |t|
    t.string   "name"
    t.string   "iata"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "coordinates"
    t.string   "content"
    t.string   "country"
    t.string   "category"
    t.string   "cityname"
  end

  create_table "car_rentals", force: :cascade do |t|
    t.string   "currency"
    t.string   "pick_up_location"
    t.string   "drop_off_location"
    t.datetime "pick_up_date_time"
    t.datetime "drop_off_date_time"
    t.integer  "driver_age"
    t.string   "company"
    t.integer  "car_id"
    t.string   "deep_link_url"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "selection_id"
    t.integer  "price_cents",        default: 0, null: false
    t.index ["car_id"], name: "index_car_rentals_on_car_id", using: :btree
    t.index ["selection_id"], name: "index_car_rentals_on_selection_id", using: :btree
  end

  create_table "cars", force: :cascade do |t|
    t.string   "name"
    t.string   "category"
    t.integer  "doors"
    t.integer  "seats"
    t.string   "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "sipp"
  end

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.string   "state"
    t.string   "trip_sku"
    t.integer  "amount_cents", default: 0, null: false
    t.json     "payment"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_orders_on_user_id", using: :btree
  end

  create_table "pois", force: :cascade do |t|
    t.string   "name"
    t.string   "photo"
    t.string   "title"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.float    "latitude"
    t.float    "longitude"
    t.string   "location"
    t.string   "description1"
    t.string   "description2"
    t.string   "description3"
    t.string   "description4"
    t.string   "description5"
  end

  create_table "regions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "description"
    t.text     "pois",        default: [],              array: true
    t.text     "airports",    default: [],              array: true
  end

  create_table "round_trip_flights", force: :cascade do |t|
    t.string   "flight1_origin_airport_iata"
    t.string   "flight1_destination_airport_iata"
    t.string   "flight2_origin_airport_iata"
    t.string   "flight2_destination_airport_iata"
    t.datetime "flight1_landing_at"
    t.datetime "flight1_take_off_at"
    t.datetime "flight2_take_off_at"
    t.datetime "flight2_landing_at"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "currency"
    t.string   "carrier1"
    t.string   "carrier2"
    t.float    "latitude_arrive"
    t.float    "longitude_arrive"
    t.float    "latitude_back"
    t.float    "longitude_back"
    t.string   "f1_number"
    t.string   "f2_number"
    t.float    "latitude_home"
    t.float    "longitude_home"
    t.integer  "region_id"
    t.integer  "price_cents",                      default: 0, null: false
    t.index ["region_id"], name: "index_round_trip_flights_on_region_id", using: :btree
  end

  create_table "searches", force: :cascade do |t|
    t.string   "city"
    t.date     "starts_on"
    t.date     "returns_on"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "nb_travelers"
    t.string   "flight1_range"
    t.string   "flight2_range"
    t.integer  "region_id"
    t.index ["region_id"], name: "index_searches_on_region_id", using: :btree
  end

  create_table "selections", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tokens", force: :cascade do |t|
    t.string   "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trips", force: :cascade do |t|
    t.date     "starts_on"
    t.date     "returns_on"
    t.integer  "nb_travelers"
    t.integer  "city_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "round_trip_flight_id"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "search_id"
    t.integer  "car_rental_id"
    t.integer  "price_cents",          default: 0, null: false
    t.string   "sku"
    t.index ["car_rental_id"], name: "index_trips_on_car_rental_id", using: :btree
    t.index ["city_id"], name: "index_trips_on_city_id", using: :btree
    t.index ["round_trip_flight_id"], name: "index_trips_on_round_trip_flight_id", using: :btree
    t.index ["search_id"], name: "index_trips_on_search_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "mail"
    t.string   "first_name"
    t.string   "name"
    t.string   "phone"
    t.string   "call_time"
    t.text     "passengers"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "car_rentals", "cars"
  add_foreign_key "car_rentals", "selections"
  add_foreign_key "orders", "users"
  add_foreign_key "round_trip_flights", "regions"
  add_foreign_key "searches", "regions"
  add_foreign_key "trips", "car_rentals"
  add_foreign_key "trips", "cities"
  add_foreign_key "trips", "round_trip_flights"
  add_foreign_key "trips", "searches"
end
