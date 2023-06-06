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

ActiveRecord::Schema[7.0].define(version: 2023_06_05_082547) do
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

  create_table "api_failure_apps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "device_infos", force: :cascade do |t|
    t.string "token"
    t.string "device_type"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_device_infos_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.bigint "sender_id", null: false
    t.bigint "receiver_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_messages_on_receiver_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "passengers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "publish_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "price"
    t.integer "seats"
    t.string "status"
    t.index ["publish_id"], name: "index_passengers_on_publish_id"
    t.index ["user_id"], name: "index_passengers_on_user_id"
  end

  create_table "publishes", force: :cascade do |t|
    t.string "source"
    t.string "destination"
    t.integer "passengers_count"
    t.string "add_city"
    t.date "date"
    t.time "time"
    t.float "set_price"
    t.text "about_ride"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "source_latitude"
    t.float "source_longitude"
    t.float "destination_latitude"
    t.float "destination_longitude"
    t.bigint "vehicle_id"
    t.string "book_instantly"
    t.string "mid_seat"
    t.json "select_route"
    t.string "status"
    t.time "estimate_time"
    t.float "add_city_longitude"
    t.float "add_city_latitude"
    t.index ["user_id"], name: "index_publishes_on_user_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.bigint "rated_user_id", null: false
    t.bigint "rating_user_id", null: false
    t.bigint "publish_id"
    t.integer "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["publish_id"], name: "index_ratings_on_publish_id"
    t.index ["rated_user_id"], name: "index_ratings_on_rated_user_id"
    t.index ["rating_user_id"], name: "index_ratings_on_rating_user_id"
  end

  create_table "rpush_apps", force: :cascade do |t|
    t.string "name", null: false
    t.string "environment"
    t.text "certificate"
    t.string "password"
    t.integer "connections", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", null: false
    t.string "auth_key"
    t.string "client_id"
    t.string "client_secret"
    t.string "access_token"
    t.datetime "access_token_expiration"
    t.text "apn_key"
    t.string "apn_key_id"
    t.string "team_id"
    t.string "bundle_id"
    t.boolean "feedback_enabled", default: true
  end

  create_table "rpush_feedback", force: :cascade do |t|
    t.string "device_token"
    t.datetime "failed_at", precision: nil, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "app_id"
    t.index ["device_token"], name: "index_rpush_feedback_on_device_token"
  end

  create_table "rpush_notifications", force: :cascade do |t|
    t.integer "badge"
    t.string "device_token"
    t.string "sound"
    t.text "alert"
    t.text "data"
    t.integer "expiry", default: 86400
    t.boolean "delivered", default: false, null: false
    t.datetime "delivered_at", precision: nil
    t.boolean "failed", default: false, null: false
    t.datetime "failed_at", precision: nil
    t.integer "error_code"
    t.text "error_description"
    t.datetime "deliver_after", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "alert_is_json", default: false, null: false
    t.string "type", null: false
    t.string "collapse_key"
    t.boolean "delay_while_idle", default: false, null: false
    t.text "registration_ids"
    t.integer "app_id", null: false
    t.integer "retries", default: 0
    t.string "uri"
    t.datetime "fail_after", precision: nil
    t.boolean "processing", default: false, null: false
    t.integer "priority"
    t.text "url_args"
    t.string "category"
    t.boolean "content_available", default: false, null: false
    t.text "notification"
    t.boolean "mutable_content", default: false, null: false
    t.string "external_device_id"
    t.string "thread_id"
    t.boolean "dry_run", default: false, null: false
    t.boolean "sound_is_json", default: false
    t.index ["delivered", "failed", "processing", "deliver_after", "created_at"], name: "index_rpush_notifications_multi", where: "((NOT delivered) AND (NOT failed))"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.string "first_name"
    t.string "last_name"
    t.date "dob"
    t.string "title"
    t.string "phone_number"
    t.text "bio"
    t.string "travel_preferences"
    t.text "postal_address"
    t.string "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.string "activation_digest"
    t.boolean "activated"
    t.datetime "activated_at"
    t.string "activate_token"
    t.string "session_key"
    t.float "average_rating", default: 0.0
    t.integer "otp", default: 0
    t.boolean "phone_verified"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "country"
    t.string "vehicle_number"
    t.string "vehicle_brand"
    t.string "vehicle_name"
    t.string "vehicle_type"
    t.string "vehicle_color"
    t.integer "vehicle_model_year"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_vehicles_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "device_infos", "users"
  add_foreign_key "messages", "users", column: "receiver_id"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "passengers", "publishes", on_delete: :cascade
  add_foreign_key "passengers", "users", on_delete: :cascade
  add_foreign_key "publishes", "users", on_delete: :cascade
  add_foreign_key "publishes", "vehicles", on_delete: :cascade
  add_foreign_key "ratings", "publishes", on_delete: :cascade
  add_foreign_key "ratings", "users", column: "rated_user_id"
  add_foreign_key "ratings", "users", column: "rating_user_id"
  add_foreign_key "vehicles", "users", on_delete: :cascade
end
