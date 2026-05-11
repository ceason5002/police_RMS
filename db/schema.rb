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

ActiveRecord::Schema[8.1].define(version: 2026_05_08_003452) do
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

  create_table "incidents", force: :cascade do |t|
    t.string "city"
    t.datetime "created_at", null: false
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

  create_table "officers", force: :cascade do |t|
    t.text "assignments"
    t.string "badge_number"
    t.datetime "created_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "rank"
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
  add_foreign_key "evidences", "incidents"
  add_foreign_key "vehicles", "people"
end
