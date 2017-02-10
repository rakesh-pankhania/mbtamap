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

ActiveRecord::Schema.define(version: 20170205021839) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "agencies", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "external_id"
    t.string   "name"
    t.string   "url"
    t.string   "timezone"
    t.string   "language"
    t.string   "phone"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "feeds", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "version"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "routes", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "agency_id"
    t.string   "external_id"
    t.string   "short_name"
    t.string   "long_name"
    t.string   "description"
    t.string   "route_type"
    t.string   "url"
    t.string   "color"
    t.string   "text_color"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["agency_id"], name: "index_routes_on_agency_id", using: :btree
  end

  create_table "service_addendums", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "service_id"
    t.datetime "date"
    t.integer  "exception_type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["service_id"], name: "index_service_addendums_on_service_id", using: :btree
  end

  create_table "services", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "external_id"
    t.boolean  "monday"
    t.boolean  "tuesday"
    t.boolean  "wednesday"
    t.boolean  "thursday"
    t.boolean  "friday"
    t.boolean  "saturday"
    t.boolean  "sunday"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "trips", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "route_id"
    t.string   "service_type"
    t.uuid     "service_id"
    t.string   "external_id"
    t.string   "headsign"
    t.string   "short_name"
    t.integer  "direction"
    t.string   "block_id"
    t.integer  "wheelchair_accessible"
    t.integer  "bikes_allowed"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["route_id"], name: "index_trips_on_route_id", using: :btree
    t.index ["service_type", "service_id"], name: "index_trips_on_service_type_and_service_id", using: :btree
  end

end
