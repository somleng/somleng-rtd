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

ActiveRecord::Schema.define(version: 20161116040558) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pgcrypto"

  create_table "projects", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer  "phone_calls_count",                                               null: false
    t.integer  "sms_count",                                                       null: false
    t.string   "name",                                                            null: false
    t.text     "description"
    t.string   "homepage"
    t.string   "twilreapi_host"
    t.text     "encrypted_twilreapi_account_sid",                                 null: false
    t.text     "encrypted_twilreapi_auth_token",                                  null: false
    t.text     "encryption_data",                                                 null: false
    t.string   "status",                                                          null: false
    t.string   "country_code",                                                    null: false
    t.decimal  "phone_call_average_unit_cost_per_minute", precision: 5, scale: 4, null: false
    t.decimal  "sms_average_unit_cost_per_message",       precision: 5, scale: 4, null: false
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
  end

end
