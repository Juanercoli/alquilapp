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

ActiveRecord::Schema[7.0].define(version: 2022_12_08_194521) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "banca_apps", force: :cascade do |t|
    t.integer "total_balance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "car_usage_histories", force: :cascade do |t|
    t.time "start"
    t.time "end"
    t.bigint "car_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_car_usage_histories_on_car_id"
    t.index ["user_id"], name: "index_car_usage_histories_on_user_id"
  end

  create_table "cards", force: :cascade do |t|
    t.bigint "user_id"
    t.string "card_number"
    t.string "name"
    t.string "surname"
    t.date "expiration_date"
    t.integer "security_code"
    t.integer "card_balance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_cards_on_user_id", unique: true
  end

  create_table "cars", force: :cascade do |t|
    t.string "brand", null: false
    t.string "patent", null: false
    t.string "model", null: false
    t.integer "vehicle_number", null: false
    t.string "color", null: false
    t.boolean "is_deleted", default: false, null: false
    t.boolean "is_visible", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patent"], name: "index_cars_on_patent", unique: true
    t.index ["vehicle_number"], name: "index_cars_on_vehicle_number", unique: true
  end

  create_table "rentals", force: :cascade do |t|
    t.integer "initial_hours_quantity"
    t.integer "extra_hours_quantity"
    t.integer "multed_hours_quantity"
    t.integer "price"
    t.boolean "is_active", default: false
    t.bigint "car_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_rentals_on_car_id"
    t.index ["user_id"], name: "index_rentals_on_user_id"
  end

  create_table "reports", force: :cascade do |t|
    t.time "date"
    t.text "content"
    t.string "report_type"
    t.bigint "car_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_reports_on_car_id"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "super_users", force: :cascade do |t|
    t.string "name", null: false
    t.string "surname", null: false
    t.string "dni", null: false
    t.string "email", null: false
    t.string "phone", null: false
    t.string "password_digest", null: false
    t.boolean "is_admin", default: false, null: false
    t.boolean "is_blocked", default: false, null: false
    t.boolean "is_deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dni"], name: "index_super_users_on_dni", unique: true
    t.index ["email"], name: "index_super_users_on_email", unique: true
    t.index ["phone"], name: "index_super_users_on_phone", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "dni", limit: 8, null: false
    t.string "name", null: false
    t.string "surname", null: false
    t.string "email", null: false
    t.string "phone", null: false
    t.string "password_digest", null: false
    t.date "driver_license_expiration", null: false
    t.date "birthdate", null: false
    t.boolean "is_blocked", default: false, null: false
    t.boolean "is_accepted", default: false, null: false
    t.boolean "is_deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dni"], name: "index_users_on_dni", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone"], name: "index_users_on_phone", unique: true
  end

  create_table "wallets", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "balance"
    t.integer "resume"
    t.integer "charge_wallet"
    t.integer "dni"
    t.boolean "verification"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wallets_on_user_id", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "car_usage_histories", "cars"
  add_foreign_key "car_usage_histories", "users"
  add_foreign_key "cards", "users"
  add_foreign_key "rentals", "cars"
  add_foreign_key "rentals", "users"
  add_foreign_key "reports", "cars"
  add_foreign_key "reports", "users"
  add_foreign_key "wallets", "users"
end
