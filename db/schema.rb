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

ActiveRecord::Schema.define(version: 20191004212504) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agencies", id: :serial, force: :cascade do |t|
    t.string "external_id", null: false
    t.string "name", null: false
    t.string "url", null: false
    t.string "timezone", null: false
    t.string "language"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_agencies_on_external_id"
  end

  create_table "feeds", id: :serial, force: :cascade do |t|
    t.string "publisher_name"
    t.string "publisher_url"
    t.string "lang"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string "version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "points", id: :serial, force: :cascade do |t|
    t.string "shape_external_id", null: false
    t.float "lattitude", null: false
    t.float "longitude", null: false
    t.integer "sequence", null: false
    t.float "dist_traveled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shape_external_id"], name: "index_points_on_shape_external_id"
  end

  create_table "routes", id: :serial, force: :cascade do |t|
    t.string "agency_external_id"
    t.string "external_id", null: false
    t.string "short_name"
    t.string "long_name"
    t.string "description"
    t.integer "route_type", null: false
    t.string "url"
    t.string "color"
    t.string "text_color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["agency_external_id"], name: "index_routes_on_agency_external_id"
    t.index ["external_id"], name: "index_routes_on_external_id"
  end

  create_table "service_addendums", id: :serial, force: :cascade do |t|
    t.string "service_external_id", null: false
    t.datetime "date", null: false
    t.integer "exception_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_external_id"], name: "index_service_addendums_on_service_external_id"
  end

  create_table "services", id: :serial, force: :cascade do |t|
    t.string "external_id", null: false
    t.boolean "monday", null: false
    t.boolean "tuesday", null: false
    t.boolean "wednesday", null: false
    t.boolean "thursday", null: false
    t.boolean "friday", null: false
    t.boolean "saturday", null: false
    t.boolean "sunday", null: false
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_services_on_external_id"
  end

  create_table "shapes", id: :serial, force: :cascade do |t|
    t.string "external_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_shapes_on_external_id"
  end

  create_table "stop_times", id: :serial, force: :cascade do |t|
    t.string "trip_external_id", null: false
    t.string "stop_external_id", null: false
    t.string "arrival_time", null: false
    t.string "departure_time", null: false
    t.integer "stop_sequence", null: false
    t.string "stop_headsign"
    t.integer "pickup_type"
    t.integer "drop_off_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stop_external_id"], name: "index_stop_times_on_stop_external_id"
    t.index ["trip_external_id"], name: "index_stop_times_on_trip_external_id"
  end

  create_table "stops", id: :serial, force: :cascade do |t|
    t.string "external_id", null: false
    t.string "parent_station_external_id"
    t.string "code"
    t.string "name", null: false
    t.string "description"
    t.float "lattitude"
    t.float "longitude"
    t.string "url"
    t.integer "location_type", default: 0
    t.integer "wheelchair_boarding", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_stops_on_external_id"
    t.index ["parent_station_external_id"], name: "index_stops_on_parent_station_external_id"
  end

  create_table "transfers", id: :serial, force: :cascade do |t|
    t.string "from_stop_external_id", null: false
    t.string "to_stop_external_id", null: false
    t.integer "transfer_type", null: false
    t.integer "min_transfer_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_stop_external_id"], name: "index_transfers_on_from_stop_external_id"
    t.index ["to_stop_external_id"], name: "index_transfers_on_to_stop_external_id"
  end

  create_table "trips", id: :serial, force: :cascade do |t|
    t.string "route_external_id", null: false
    t.string "service_external_id", null: false
    t.string "shape_external_id"
    t.string "external_id", null: false
    t.string "headsign"
    t.string "short_name"
    t.integer "direction_id"
    t.string "block_id"
    t.integer "wheelchair_accessible"
    t.integer "bikes_allowed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_trips_on_external_id"
    t.index ["route_external_id"], name: "index_trips_on_route_external_id"
    t.index ["service_external_id"], name: "index_trips_on_service_external_id"
  end

end
