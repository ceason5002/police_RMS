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

ActiveRecord::Schema[8.1].define(version: 2026_05_15_155525) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "alert_subscriptions", force: :cascade do |t|
    t.boolean "confirmed", default: false, null: false
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.string "zip_code", null: false
    t.index ["email"], name: "index_alert_subscriptions_on_email", unique: true
    t.index ["token"], name: "index_alert_subscriptions_on_token", unique: true
  end

  create_table "arrests", force: :cascade do |t|
    t.datetime "arrested_at"
    t.text "charges"
    t.datetime "created_at", null: false
    t.integer "incident_id", null: false
    t.integer "person_id", null: false
    t.datetime "updated_at", null: false
    t.index ["incident_id"], name: "index_arrests_on_incident_id"
    t.index ["person_id"], name: "index_arrests_on_person_id"
  end

  create_table "audit_logs", force: :cascade do |t|
    t.string "action"
    t.datetime "created_at", null: false
    t.text "details"
    t.string "ip_address"
    t.integer "resource_id"
    t.string "resource_type"
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "bolos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "created_by_id"
    t.datetime "expires_at"
    t.integer "issuing_officer_id"
    t.string "last_known_location"
    t.string "status", default: "Active", null: false
    t.text "subject_description"
    t.datetime "updated_at", null: false
    t.text "vehicle_description"
    t.index ["created_by_id"], name: "index_bolos_on_created_by_id"
    t.index ["issuing_officer_id"], name: "index_bolos_on_issuing_officer_id"
    t.index ["status"], name: "index_bolos_on_status"
  end

  create_table "cad_calls", force: :cascade do |t|
    t.string "call_number", null: false
    t.string "call_type", null: false
    t.string "caller_name"
    t.string "caller_phone"
    t.datetime "cleared_at"
    t.datetime "created_at", null: false
    t.integer "created_by_id"
    t.text "description"
    t.datetime "dispatched_at"
    t.integer "incident_id"
    t.decimal "latitude", precision: 10, scale: 7
    t.string "location", null: false
    t.decimal "longitude", precision: 10, scale: 7
    t.datetime "on_scene_at"
    t.integer "priority", default: 3, null: false
    t.datetime "received_at", null: false
    t.string "status", default: "Pending", null: false
    t.datetime "updated_at", null: false
    t.index ["call_number"], name: "index_cad_calls_on_call_number", unique: true
    t.index ["created_by_id"], name: "index_cad_calls_on_created_by_id"
    t.index ["incident_id"], name: "index_cad_calls_on_incident_id"
    t.index ["priority"], name: "index_cad_calls_on_priority"
    t.index ["status"], name: "index_cad_calls_on_status"
  end

  create_table "cad_units", force: :cascade do |t|
    t.integer "assigned_officer_id"
    t.datetime "created_at", null: false
    t.string "status", default: "Available", null: false
    t.string "unit_number", null: false
    t.string "unit_type", null: false
    t.datetime "updated_at", null: false
    t.index ["assigned_officer_id"], name: "index_cad_units_on_assigned_officer_id"
    t.index ["status"], name: "index_cad_units_on_status"
    t.index ["unit_number"], name: "index_cad_units_on_unit_number", unique: true
  end

  create_table "call_notes", force: :cascade do |t|
    t.text "body", null: false
    t.integer "cad_call_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["cad_call_id"], name: "index_call_notes_on_cad_call_id"
    t.index ["user_id"], name: "index_call_notes_on_user_id"
  end

  create_table "call_units", force: :cascade do |t|
    t.datetime "assigned_at", null: false
    t.integer "cad_call_id", null: false
    t.integer "cad_unit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cad_call_id", "cad_unit_id"], name: "index_call_units_on_cad_call_id_and_cad_unit_id", unique: true
    t.index ["cad_call_id"], name: "index_call_units_on_cad_call_id"
    t.index ["cad_unit_id"], name: "index_call_units_on_cad_unit_id"
  end

  create_table "community_events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.datetime "ends_at"
    t.string "event_type", default: "General", null: false
    t.string "location"
    t.boolean "published", default: false, null: false
    t.datetime "starts_at", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
  end

  create_table "community_requests", force: :cascade do |t|
    t.string "contact_email"
    t.string "contact_name"
    t.string "contact_phone"
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.integer "incident_id"
    t.text "internal_notes"
    t.string "location", null: false
    t.string "request_type", null: false
    t.string "status", default: "New", null: false
    t.datetime "updated_at", null: false
    t.index ["incident_id"], name: "index_community_requests_on_incident_id"
  end

  create_table "community_tips", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.text "internal_notes"
    t.string "location"
    t.string "status", default: "New", null: false
    t.string "tip_type", null: false
    t.datetime "updated_at", null: false
  end

  create_table "crime_cases", force: :cascade do |t|
    t.string "case_number"
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "lead_officer_id"
    t.string "status"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "evidences", force: :cascade do |t|
    t.text "chain_of_custody"
    t.datetime "collected_at"
    t.string "collected_by"
    t.datetime "created_at", null: false
    t.string "description"
    t.string "evidence_number"
    t.integer "incident_id", null: false
    t.string "location_stored"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["incident_id"], name: "index_evidences_on_incident_id"
  end

  create_table "fleet_logs", force: :cascade do |t|
    t.decimal "cost", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.string "description", null: false
    t.integer "fleet_vehicle_id", null: false
    t.string "log_type", null: false
    t.datetime "logged_at", null: false
    t.integer "mileage"
    t.text "notes"
    t.string "performed_by"
    t.datetime "updated_at", null: false
    t.index ["fleet_vehicle_id"], name: "index_fleet_logs_on_fleet_vehicle_id"
  end

  create_table "fleet_vehicles", force: :cascade do |t|
    t.string "color"
    t.datetime "created_at", null: false
    t.integer "current_mileage", default: 0
    t.string "make", null: false
    t.string "model", null: false
    t.text "notes"
    t.string "status", default: "Active", null: false
    t.string "unit_number", null: false
    t.datetime "updated_at", null: false
    t.string "vin"
    t.integer "year", null: false
    t.index ["status"], name: "index_fleet_vehicles_on_status"
    t.index ["unit_number"], name: "index_fleet_vehicles_on_unit_number", unique: true
  end

  create_table "incidents", force: :cascade do |t|
    t.string "city"
    t.datetime "created_at", null: false
    t.integer "crime_case_id"
    t.boolean "flagged", default: false, null: false
    t.string "flagged_reason"
    t.string "incident_type"
    t.float "latitude"
    t.float "longitude"
    t.text "narrative"
    t.datetime "occurred_at"
    t.string "report_number"
    t.datetime "reported_at"
    t.string "state"
    t.string "status"
    t.string "street_address"
    t.datetime "updated_at", null: false
    t.string "zip_code"
  end

  create_table "news_posts", force: :cascade do |t|
    t.string "author_name"
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "published_at"
    t.string "status", default: "Draft", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
  end

  create_table "officer_complaints", force: :cascade do |t|
    t.string "assigned_investigator"
    t.string "complainant_contact"
    t.string "complainant_name"
    t.string "complaint_type", null: false
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.date "incident_date"
    t.text "internal_notes"
    t.integer "officer_id"
    t.datetime "received_at", null: false
    t.string "status", default: "New", null: false
    t.datetime "updated_at", null: false
    t.index ["officer_id"], name: "index_officer_complaints_on_officer_id"
    t.index ["status"], name: "index_officer_complaints_on_status"
  end

  create_table "officer_trainings", force: :cascade do |t|
    t.date "completed_on"
    t.datetime "created_at", null: false
    t.date "expires_on"
    t.decimal "hours", precision: 5, scale: 2
    t.string "instructor"
    t.text "notes"
    t.integer "officer_id", null: false
    t.string "status", default: "Scheduled", null: false
    t.string "title", null: false
    t.string "training_type", null: false
    t.datetime "updated_at", null: false
    t.index ["officer_id"], name: "index_officer_trainings_on_officer_id"
    t.index ["status"], name: "index_officer_trainings_on_status"
  end

  create_table "officer_units", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "officer_id", null: false
    t.integer "unit_id", null: false
    t.datetime "updated_at", null: false
    t.index ["officer_id"], name: "index_officer_units_on_officer_id"
    t.index ["unit_id"], name: "index_officer_units_on_unit_id"
  end

  create_table "officers", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.text "assignments"
    t.string "badge_number"
    t.datetime "created_at", null: false
    t.boolean "featured", default: false, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "rank"
    t.text "spotlight_bio"
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.string "city"
    t.datetime "created_at", null: false
    t.date "date_of_birth"
    t.string "first_name"
    t.string "last_name"
    t.text "notes"
    t.string "state"
    t.string "street_address"
    t.datetime "updated_at", null: false
    t.string "zip_code"
  end

  create_table "unit_status_logs", force: :cascade do |t|
    t.integer "cad_unit_id", null: false
    t.datetime "changed_at", null: false
    t.integer "changed_by_id"
    t.datetime "created_at", null: false
    t.string "status", null: false
    t.datetime "updated_at", null: false
    t.index ["cad_unit_id"], name: "index_unit_status_logs_on_cad_unit_id"
    t.index ["changed_at"], name: "index_unit_status_logs_on_changed_at"
    t.index ["changed_by_id"], name: "index_unit_status_logs_on_changed_by_id"
  end

  create_table "units", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.string "unit_type"
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "login_id"
    t.integer "officer_id"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "role"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["login_id"], name: "index_users_on_login_id", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "color"
    t.datetime "created_at", null: false
    t.string "make"
    t.string "model"
    t.integer "person_id", null: false
    t.string "plate_number"
    t.datetime "updated_at", null: false
    t.integer "year"
    t.index ["person_id"], name: "index_vehicles_on_person_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "arrests", "incidents"
  add_foreign_key "arrests", "people"
  add_foreign_key "bolos", "officers", column: "issuing_officer_id"
  add_foreign_key "bolos", "users", column: "created_by_id"
  add_foreign_key "cad_calls", "incidents"
  add_foreign_key "cad_calls", "users", column: "created_by_id"
  add_foreign_key "cad_units", "officers", column: "assigned_officer_id"
  add_foreign_key "call_notes", "cad_calls"
  add_foreign_key "call_notes", "users"
  add_foreign_key "call_units", "cad_calls"
  add_foreign_key "call_units", "cad_units"
  add_foreign_key "community_requests", "incidents"
  add_foreign_key "evidences", "incidents"
  add_foreign_key "fleet_logs", "fleet_vehicles"
  add_foreign_key "officer_complaints", "officers"
  add_foreign_key "officer_trainings", "officers"
  add_foreign_key "officer_units", "officers"
  add_foreign_key "officer_units", "units"
  add_foreign_key "unit_status_logs", "cad_units"
  add_foreign_key "unit_status_logs", "users", column: "changed_by_id"
  add_foreign_key "vehicles", "people"
end
