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

ActiveRecord::Schema[7.2].define(version: 2024_11_01_084525) do
  create_table "alarm_notes", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "note"
    t.bigint "alarm_id", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alarm_id"], name: "index_alarm_notes_on_alarm_id"
    t.index ["user_id"], name: "index_alarm_notes_on_user_id"
  end

  create_table "alarms", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "url"
    t.string "present_val"
    t.string "type"
    t.string "message"
    t.boolean "ack", default: false
    t.string "status"
    t.bigint "point_id"
    t.bigint "device_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "note"
    t.index ["device_id"], name: "index_alarms_on_device_id"
    t.index ["point_id"], name: "index_alarms_on_point_id"
    t.index ["url"], name: "index_alarms_on_url", unique: true
  end

  create_table "area_refs", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.bigint "area_id"
    t.bigint "parent_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["area_id"], name: "index_area_refs_on_area_id"
    t.index ["parent_id"], name: "index_area_refs_on_parent_id"
  end

  create_table "areas", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "location_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["location_id"], name: "index_areas_on_location_id"
  end

  create_table "calendar_items", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.bigint "calendar_id", null: false
    t.string "event_type"
    t.date "start_date"
    t.date "end_date"
    t.time "start_time"
    t.time "end_time"
    t.string "recur_on"
    t.string "type"
    t.index ["calendar_id"], name: "index_calendar_items_on_calendar_id"
  end

  create_table "calendars", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
  end

  create_table "calendars_locations", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.bigint "calendar_id", null: false
    t.bigint "location_id", null: false
    t.index ["calendar_id"], name: "index_calendars_locations_on_calendar_id"
    t.index ["location_id"], name: "index_calendars_locations_on_location_id"
  end

  create_table "customers", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "device_documentations", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.bigint "device_id"
    t.bigint "location_id"
    t.string "name"
    t.string "display_name"
    t.text "documentation_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_device_documentations_on_device_id"
    t.index ["location_id"], name: "index_device_documentations_on_location_id"
  end

  create_table "devices", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.string "device_type"
    t.string "url"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "areas_id"
    t.bigint "area_id"
    t.string "description"
    t.date "installed_on"
    t.bigint "administrator_id"
    t.text "technique"
    t.string "interface"
    t.string "protocol"
    t.text "image_url"
    t.bigint "engineer_id"
    t.string "link"
    t.string "link_display"
    t.boolean "visible", default: true
    t.string "bim_id"
    t.string "type"
    t.index ["administrator_id"], name: "index_devices_on_administrator_id"
    t.index ["area_id"], name: "index_devices_on_area_id"
    t.index ["areas_id"], name: "index_devices_on_areas_id"
    t.index ["engineer_id"], name: "index_devices_on_engineer_id"
  end

  create_table "energy_tariffs", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.decimal "energy_high_tariff", precision: 6, scale: 4
    t.decimal "energy_low_tariff", precision: 6, scale: 4
    t.decimal "energy_return_high_tariff", precision: 6, scale: 4
    t.decimal "energy_return_low_tariff", precision: 6, scale: 4
    t.decimal "gas_tariff", precision: 6, scale: 4
    t.date "contract_start_date"
    t.date "contract_end_date"
    t.integer "tariff_type", default: 0
    t.bigint "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "gas_tax_bracket_1", precision: 7, scale: 5
    t.decimal "gas_tax_bracket_2", precision: 7, scale: 5
    t.decimal "gas_tax_bracket_3", precision: 7, scale: 5
    t.decimal "gas_tax_bracket_4", precision: 7, scale: 5
    t.decimal "gas_tax_bracket_5", precision: 7, scale: 5
    t.decimal "electricity_tax_bracket_1", precision: 7, scale: 5
    t.decimal "electricity_tax_bracket_2", precision: 7, scale: 5
    t.decimal "electricity_tax_bracket_3", precision: 7, scale: 5
    t.decimal "electricity_tax_bracket_4", precision: 7, scale: 5
    t.decimal "electricity_tax_bracket_5", precision: 7, scale: 5
    t.index ["contract_end_date"], name: "index_energy_tariffs_on_contract_end_date"
    t.index ["contract_start_date"], name: "index_energy_tariffs_on_contract_start_date"
    t.index ["location_id"], name: "index_energy_tariffs_on_location_id"
    t.index ["tariff_type"], name: "index_energy_tariffs_on_tariff_type"
  end

  create_table "engineers", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.string "phonenumber"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "email"
    t.string "engineer_link"
    t.bigint "user_id"
    t.bigint "organisation_id"
    t.index ["organisation_id"], name: "index_engineers_on_organisation_id"
    t.index ["user_id"], name: "index_engineers_on_user_id"
  end

  create_table "engineers_locations", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.bigint "engineer_id"
    t.bigint "location_id"
    t.index ["engineer_id"], name: "index_engineers_locations_on_engineer_id"
    t.index ["location_id"], name: "index_engineers_locations_on_location_id"
  end

  create_table "folder_refs", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.bigint "folder_id"
    t.bigint "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["folder_id"], name: "index_folder_refs_on_folder_id"
    t.index ["parent_id"], name: "index_folder_refs_on_parent_id"
  end

  create_table "folders", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "display_name"
    t.integer "calculation", limit: 1, default: 0, null: false
    t.string "url"
    t.bigint "sim_link"
    t.bigint "device_id"
    t.index ["device_id"], name: "index_folders_on_device_id"
    t.index ["sim_link"], name: "index_folders_on_sim_link"
  end

  create_table "folders_points", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.bigint "folder_id"
    t.bigint "point_id"
    t.index ["folder_id"], name: "index_folders_points_on_folder_id"
    t.index ["point_id"], name: "index_folders_points_on_point_id"
  end

  create_table "haystack_taggings", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.bigint "haystack_tag_id"
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["haystack_tag_id"], name: "index_haystack_taggings_on_haystack_tag_id"
    t.index ["taggable_type", "taggable_id"], name: "index_haystack_taggings_on_taggable"
  end

  create_table "haystack_tags", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "haystack_marker"
    t.bigint "parent_tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_tag_id"], name: "index_haystack_tags_on_parent_tag_id"
  end

  create_table "identifiers", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.string "display_name"
    t.string "nfc_number"
    t.bigint "location_id"
    t.bigint "area_id"
    t.string "guid"
    t.text "reason_for_installation"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["area_id"], name: "index_identifiers_on_area_id"
    t.index ["location_id"], name: "index_identifiers_on_location_id"
  end

  create_table "locations", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "organisation_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "display_name"
    t.string "street"
    t.string "streetnumber"
    t.string "zipcode"
    t.text "reason_for_installation"
    t.string "town"
    t.decimal "latitude", precision: 9, scale: 7
    t.decimal "longitude", precision: 10, scale: 7
    t.integer "usable_sqmtr_building"
    t.integer "sqmtr_building"
    t.bigint "calendar_id"
    t.index ["calendar_id"], name: "index_locations_on_calendar_id"
    t.index ["latitude"], name: "index_locations_on_latitude"
    t.index ["longitude"], name: "index_locations_on_longitude"
    t.index ["organisation_id"], name: "index_locations_on_organisation_id"
    t.index ["sqmtr_building"], name: "index_locations_on_sqmtr_building"
    t.index ["town"], name: "index_locations_on_town"
    t.index ["usable_sqmtr_building"], name: "index_locations_on_usable_sqmtr_building"
    t.index ["zipcode"], name: "index_locations_on_zipcode"
  end

  create_table "operational_schedules", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "type"
    t.integer "weekday"
    t.time "start_time"
    t.time "end_time"
    t.bigint "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["end_time"], name: "index_operational_schedules_on_end_time"
    t.index ["location_id"], name: "index_operational_schedules_on_location_id"
    t.index ["start_time"], name: "index_operational_schedules_on_start_time"
    t.index ["type"], name: "index_operational_schedules_on_type"
    t.index ["weekday"], name: "index_operational_schedules_on_weekday"
  end

  create_table "organisations", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "organisation_type"
  end

  create_table "points", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "url"
    t.text "notes"
    t.bigint "device_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bim_id"
    t.index ["device_id"], name: "index_points_on_device_id"
    t.index ["updated_at"], name: "index_points_on_updated_at"
    t.index ["url"], name: "index_points_on_url", unique: true
  end

  create_table "points_tags", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.bigint "point_id", null: false
    t.bigint "tag_id", null: false
    t.index ["point_id"], name: "index_points_tags_on_point_id"
    t.index ["tag_id"], name: "index_points_tags_on_tag_id"
  end

  create_table "scope_inspections", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.bigint "location_id"
    t.string "name"
    t.string "display_name"
    t.text "documentation_data"
    t.boolean "recovery_statement_present"
    t.text "recovery_statement_data"
    t.date "new_inspection_date"
    t.date "inspection_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_scope_inspections_on_location_id"
  end

  create_table "settings", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.integer "building_energy_percentage"
    t.integer "beng2_target", default: 70
    t.integer "beng3_target", default: 40
    t.string "co2_scale", default: "FSS"
    t.bigint "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "temperature_scale"
    t.string "humidity_scale"
    t.string "weii_standard"
    t.string "beng2_standard"
    t.index ["beng2_standard"], name: "index_settings_on_beng2_standard"
    t.index ["beng2_target"], name: "index_settings_on_beng2_target"
    t.index ["beng3_target"], name: "index_settings_on_beng3_target"
    t.index ["co2_scale"], name: "index_settings_on_co2_scale"
    t.index ["humidity_scale"], name: "index_settings_on_humidity_scale"
    t.index ["location_id"], name: "index_settings_on_location_id"
    t.index ["temperature_scale"], name: "index_settings_on_temperature_scale"
    t.index ["weii_standard"], name: "index_settings_on_weii_standard"
  end

  create_table "tags", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hidden", default: false
  end

  create_table "user_locations", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.bigint "location_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_user_locations_on_location_id"
    t.index ["user_id"], name: "index_user_locations_on_user_id"
  end

  create_table "users", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "encrypted_otp_secret"
    t.string "encrypted_otp_secret_iv"
    t.string "encrypted_otp_secret_salt"
    t.integer "consumed_timestep"
    t.boolean "otp_required_for_login"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.integer "role", default: 0
    t.integer "otp_required"
    t.integer "theme"
    t.integer "language"
    t.boolean "mail_report", default: true
    t.string "otp_secret"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "users_locations", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.bigint "location_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_users_locations_on_location_id"
    t.index ["user_id"], name: "index_users_locations_on_user_id"
  end

  add_foreign_key "alarm_notes", "alarms"
  add_foreign_key "alarm_notes", "users"
  add_foreign_key "area_refs", "areas"
  add_foreign_key "area_refs", "areas", column: "parent_id"
  add_foreign_key "areas", "locations"
  add_foreign_key "calendar_items", "calendars"
  add_foreign_key "calendars_locations", "calendars"
  add_foreign_key "calendars_locations", "locations"
  add_foreign_key "device_documentations", "devices"
  add_foreign_key "device_documentations", "locations"
  add_foreign_key "devices", "areas"
  add_foreign_key "devices", "areas", column: "areas_id"
  add_foreign_key "devices", "engineers"
  add_foreign_key "devices", "engineers", column: "administrator_id"
  add_foreign_key "engineers_locations", "engineers"
  add_foreign_key "engineers_locations", "locations"
  add_foreign_key "folder_refs", "folders"
  add_foreign_key "folder_refs", "folders", column: "parent_id"
  add_foreign_key "folders", "devices"
  add_foreign_key "folders_points", "folders"
  add_foreign_key "folders_points", "points"
  add_foreign_key "haystack_taggings", "haystack_tags"
  add_foreign_key "haystack_tags", "haystack_tags", column: "parent_tag_id"
  add_foreign_key "identifiers", "areas"
  add_foreign_key "identifiers", "locations"
  add_foreign_key "locations", "calendars"
  add_foreign_key "locations", "organisations"
  add_foreign_key "points_tags", "points"
  add_foreign_key "points_tags", "tags"
  add_foreign_key "scope_inspections", "locations"
  add_foreign_key "user_locations", "locations"
  add_foreign_key "user_locations", "users"
  add_foreign_key "users_locations", "locations"
  add_foreign_key "users_locations", "users"
end
