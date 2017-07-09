# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20170514184944) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string   "street_name"
    t.string   "street_number"
    t.string   "floor_number"
    t.string   "apartment"
    t.string   "location_description"
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "city_id"
  end

  add_index "addresses", ["city_id"], name: "index_addresses_on_city_id", using: :btree

  create_table "bids", force: :cascade do |t|
    t.text     "description"
    t.integer  "price_cents",             default: 0,     null: false
    t.string   "price_currency",          default: "ARS", null: false
    t.integer  "carrier_id"
    t.integer  "shipment_publication_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "bids", ["carrier_id"], name: "index_bids_on_carrier_id", using: :btree
  add_index "bids", ["shipment_publication_id"], name: "index_bids_on_shipment_publication_id", using: :btree

  create_table "budgets", force: :cascade do |t|
    t.integer  "price_cents",         default: 0,     null: false
    t.string   "price_currency",      default: "ARS", null: false
    t.integer  "shipment_request_id"
    t.boolean  "accepted",            default: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "budgets", ["shipment_request_id"], name: "index_budgets_on_shipment_request_id", using: :btree

  create_table "carrier_scorings", force: :cascade do |t|
    t.integer  "shipment_publication_id"
    t.integer  "service_quality"
    t.integer  "delivery_time"
    t.text     "feedback"
    t.boolean  "recommended"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "carrier_scorings", ["shipment_publication_id"], name: "index_carrier_scorings_on_shipment_publication_id", using: :btree

  create_table "carriers", force: :cascade do |t|
    t.string   "email",                        default: "", null: false
    t.string   "encrypted_password",           default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",              default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "business_name"
    t.string   "phone_number"
    t.string   "company_description"
    t.string   "profile_picture_file_name"
    t.string   "profile_picture_content_type"
    t.integer  "profile_picture_file_size"
    t.datetime "profile_picture_updated_at"
    t.integer  "address_id"
    t.string   "api_token"
  end

  add_index "carriers", ["address_id"], name: "index_carriers_on_address_id", using: :btree
  add_index "carriers", ["confirmation_token"], name: "index_carriers_on_confirmation_token", unique: true, using: :btree
  add_index "carriers", ["email"], name: "index_carriers_on_email", unique: true, using: :btree
  add_index "carriers", ["reset_password_token"], name: "index_carriers_on_reset_password_token", unique: true, using: :btree
  add_index "carriers", ["unlock_token"], name: "index_carriers_on_unlock_token", unique: true, using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.text     "description",           default: ""
    t.boolean  "are_measures_required", default: true
    t.boolean  "is_weight_required",    default: true
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "parent_category_id"
    t.string   "code_name"
  end

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.integer  "region_id"
    t.integer  "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "cities", ["country_id"], name: "index_cities_on_country_id", using: :btree
  add_index "cities", ["region_id"], name: "index_cities_on_region_id", using: :btree

  create_table "conversations", force: :cascade do |t|
    t.integer  "topic_id"
    t.string   "topic_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conversations", ["topic_type", "topic_id"], name: "index_conversations_on_topic_type_and_topic_id", using: :btree

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "items", force: :cascade do |t|
    t.string   "name",                    default: "", null: false
    t.integer  "length_m"
    t.integer  "length_cm"
    t.integer  "width_m"
    t.integer  "width_cm"
    t.integer  "height_m"
    t.integer  "height_cm"
    t.float    "weight_kg"
    t.integer  "quantity"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "shipment_publication_id"
  end

  add_index "items", ["shipment_publication_id"], name: "index_items_on_shipment_publication_id", using: :btree

  create_table "location_reports", force: :cascade do |t|
    t.integer  "trip_id"
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "location_reports", ["trip_id"], name: "index_location_reports_on_trip_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.text     "body"
    t.integer  "person_id"
    t.string   "person_type"
    t.integer  "conversation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree
  add_index "messages", ["person_type", "person_id"], name: "index_messages_on_person_type_and_person_id", using: :btree

  create_table "regions", force: :cascade do |t|
    t.string   "name"
    t.integer  "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "regions", ["country_id"], name: "index_regions_on_country_id", using: :btree

  create_table "sellers", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "business_name"
    t.string   "phone_number"
    t.string   "address"
    t.string   "api_token"
  end

  add_index "sellers", ["confirmation_token"], name: "index_sellers_on_confirmation_token", unique: true, using: :btree
  add_index "sellers", ["email"], name: "index_sellers_on_email", unique: true, using: :btree
  add_index "sellers", ["reset_password_token"], name: "index_sellers_on_reset_password_token", unique: true, using: :btree
  add_index "sellers", ["unlock_token"], name: "index_sellers_on_unlock_token", unique: true, using: :btree

  create_table "service_conditions", force: :cascade do |t|
    t.time     "from_time"
    t.time     "to_time"
    t.date     "date"
    t.date     "from_date"
    t.date     "to_date"
    t.string   "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shipment_publications", force: :cascade do |t|
    t.string   "title"
    t.boolean  "special_care",                  default: false
    t.boolean  "blanket_wrap",                  default: false
    t.boolean  "canceled",                      default: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "client_id"
    t.string   "client_type"
    t.integer  "carrier_id"
    t.integer  "pickup_address_id"
    t.integer  "delivery_address_id"
    t.integer  "pickup_service_condition_id"
    t.integer  "delivery_service_condition_id"
    t.integer  "category_id"
    t.integer  "accepted_bid_id"
    t.integer  "trip_id"
    t.string   "status"
  end

  add_index "shipment_publications", ["carrier_id"], name: "index_shipment_publications_on_carrier_id", using: :btree
  add_index "shipment_publications", ["category_id"], name: "index_shipment_publications_on_category_id", using: :btree
  add_index "shipment_publications", ["client_type", "client_id"], name: "index_shipment_publications_on_client_type_and_client_id", using: :btree
  add_index "shipment_publications", ["trip_id"], name: "index_shipment_publications_on_trip_id", using: :btree

  create_table "shipment_requests", force: :cascade do |t|
    t.text     "items_description"
    t.integer  "user_id"
    t.integer  "user_trip_publication_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "shipment_requests", ["user_id"], name: "index_shipment_requests_on_user_id", using: :btree
  add_index "shipment_requests", ["user_trip_publication_id"], name: "index_shipment_requests_on_user_trip_publication_id", using: :btree

  create_table "trips", force: :cascade do |t|
    t.string   "status"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "origin_id"
    t.integer  "destination_id"
    t.date     "departure_date"
    t.date     "arrival_date"
    t.integer  "carrier_id"
  end

  add_index "trips", ["carrier_id"], name: "index_trips_on_carrier_id", using: :btree

  create_table "user_trip_publications", force: :cascade do |t|
    t.integer  "user_id"
    t.date     "departure_date"
    t.time     "departure_time"
    t.date     "arrival_date"
    t.time     "arrival_time"
    t.string   "vehicle_description"
    t.string   "origin_location_description"
    t.string   "destination_location_description"
    t.boolean  "canceled",                         default: false
    t.float    "origin_lat"
    t.float    "origin_lng"
    t.float    "destination_lat"
    t.float    "destination_lng"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.integer  "origin_city_id"
    t.integer  "destination_city_id"
  end

  add_index "user_trip_publications", ["user_id"], name: "index_user_trip_publications_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.string   "last_name"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  add_foreign_key "addresses", "cities"
  add_foreign_key "bids", "carriers"
  add_foreign_key "bids", "shipment_publications"
  add_foreign_key "budgets", "shipment_requests"
  add_foreign_key "carrier_scorings", "shipment_publications"
  add_foreign_key "carriers", "addresses"
  add_foreign_key "categories", "categories", column: "parent_category_id"
  add_foreign_key "cities", "countries"
  add_foreign_key "cities", "regions"
  add_foreign_key "identities", "users"
  add_foreign_key "items", "shipment_publications"
  add_foreign_key "location_reports", "trips"
  add_foreign_key "messages", "conversations"
  add_foreign_key "regions", "countries"
  add_foreign_key "shipment_publications", "addresses", column: "delivery_address_id"
  add_foreign_key "shipment_publications", "addresses", column: "pickup_address_id"
  add_foreign_key "shipment_publications", "bids", column: "accepted_bid_id"
  add_foreign_key "shipment_publications", "carriers"
  add_foreign_key "shipment_publications", "categories"
  add_foreign_key "shipment_publications", "service_conditions", column: "delivery_service_condition_id"
  add_foreign_key "shipment_publications", "service_conditions", column: "pickup_service_condition_id"
  add_foreign_key "shipment_publications", "trips"
  add_foreign_key "shipment_requests", "user_trip_publications"
  add_foreign_key "shipment_requests", "users"
  add_foreign_key "trips", "cities", column: "destination_id"
  add_foreign_key "trips", "cities", column: "origin_id"
  add_foreign_key "user_trip_publications", "cities", column: "destination_city_id"
  add_foreign_key "user_trip_publications", "cities", column: "origin_city_id"
  add_foreign_key "user_trip_publications", "users"
end
