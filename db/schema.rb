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

ActiveRecord::Schema.define(version: 20170218124950) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pgcrypto"

  create_table "project_aggregations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid     "project_id",                 null: false
    t.date     "date",                       null: false
    t.integer  "calls_count",                null: false
    t.integer  "calls_price_cents",          null: false
    t.integer  "calls_inbound_count",        null: false
    t.integer  "calls_inbound_price_cents",  null: false
    t.integer  "calls_outbound_count",       null: false
    t.integer  "calls_outbound_price_cents", null: false
    t.integer  "sms_count",                  null: false
    t.integer  "sms_price_cents",            null: false
    t.integer  "sms_inbound_count",          null: false
    t.integer  "sms_inbound_price_cents",    null: false
    t.integer  "sms_outbound_count",         null: false
    t.integer  "sms_outbound_price_cents",   null: false
    t.integer  "calls_minutes",              null: false
    t.integer  "calls_inbound_minutes",      null: false
    t.integer  "calls_outbound_minutes",     null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["date", "project_id"], name: "index_project_aggregations_on_date_and_project_id", unique: true, using: :btree
    t.index ["project_id"], name: "index_project_aggregations_on_project_id", using: :btree
  end

  create_table "projects", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string   "name",                            null: false
    t.text     "description"
    t.string   "homepage"
    t.string   "twilreapi_host",                  null: false
    t.text     "encrypted_twilreapi_account_sid", null: false
    t.text     "encrypted_twilreapi_auth_token",  null: false
    t.text     "encryption_data",                 null: false
    t.string   "status",                          null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.uuid     "twilio_price_id",                 null: false
    t.index ["twilio_price_id"], name: "index_projects_on_twilio_price_id", using: :btree
  end

  create_table "twilio_prices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer  "average_outbound_voice_price_microunits", null: false
    t.integer  "average_outbound_sms_price_microunits",   null: false
    t.string   "country_code",                            null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "average_inbound_voice_price_microunits",  null: false
    t.integer  "average_inbound_sms_price_microunits",    null: false
    t.index ["country_code"], name: "index_twilio_prices_on_country_code", unique: true, using: :btree
  end

  add_foreign_key "project_aggregations", "projects"
  add_foreign_key "projects", "twilio_prices"
end
