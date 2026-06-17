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

ActiveRecord::Schema[7.2].define(version: 2026_06_17_191003) do
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

  create_table "best_laps", force: :cascade do |t|
    t.bigint "driver_id", null: false
    t.bigint "track_id"
    t.bigint "kart_type_id"
    t.bigint "race_id"
    t.integer "lap_time_ms"
    t.datetime "recorded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_best_laps_on_driver_id"
    t.index ["kart_type_id"], name: "index_best_laps_on_kart_type_id"
    t.index ["race_id"], name: "index_best_laps_on_race_id"
    t.index ["track_id"], name: "index_best_laps_on_track_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "session_price_id"
    t.bigint "kart_type_id"
    t.datetime "starts_at"
    t.integer "party_size"
    t.integer "status"
    t.integer "total_cents"
    t.string "currency"
    t.text "notes"
    t.string "reference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kart_type_id"], name: "index_bookings_on_kart_type_id"
    t.index ["reference"], name: "index_bookings_on_reference", unique: true
    t.index ["session_price_id"], name: "index_bookings_on_session_price_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "championship_standings", force: :cascade do |t|
    t.bigint "competition_id", null: false
    t.bigint "driver_id", null: false
    t.integer "points"
    t.integer "position"
    t.integer "rounds_completed"
    t.integer "wins"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["competition_id"], name: "index_championship_standings_on_competition_id"
    t.index ["driver_id"], name: "index_championship_standings_on_driver_id"
  end

  create_table "competitions", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.text "description"
    t.integer "format"
    t.integer "status"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "registration_opens_at"
    t.datetime "registration_closes_at"
    t.integer "capacity"
    t.integer "entry_fee_cents"
    t.string "currency"
    t.bigint "track_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_competitions_on_slug", unique: true
    t.index ["track_id"], name: "index_competitions_on_track_id"
  end

  create_table "drivers", force: :cascade do |t|
    t.bigint "user_id"
    t.string "nickname"
    t.string "slug"
    t.string "transponder_id"
    t.text "bio"
    t.string "country"
    t.integer "total_races"
    t.integer "best_lap_ms"
    t.integer "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_drivers_on_slug", unique: true
    t.index ["user_id"], name: "index_drivers_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.text "description"
    t.integer "kind"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string "location"
    t.boolean "featured"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_events_on_slug", unique: true
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "gallery_items", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "media_kind"
    t.string "video_url"
    t.integer "category"
    t.integer "position"
    t.boolean "featured"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "kart_types", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.integer "category"
    t.text "description"
    t.integer "top_speed_kmh"
    t.decimal "power_hp"
    t.string "engine"
    t.integer "weight_kg"
    t.integer "min_age"
    t.integer "min_height_cm"
    t.jsonb "specs"
    t.integer "position"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_kart_types_on_slug", unique: true
  end

  create_table "laps", force: :cascade do |t|
    t.bigint "race_entry_id", null: false
    t.integer "lap_number"
    t.integer "lap_time_ms"
    t.jsonb "sector_times"
    t.datetime "recorded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["race_entry_id"], name: "index_laps_on_race_entry_id"
  end

  create_table "membership_plans", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.text "description"
    t.integer "price_cents"
    t.string "currency"
    t.integer "period"
    t.jsonb "benefits"
    t.boolean "popular"
    t.integer "position"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_membership_plans_on_slug", unique: true
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "kind"
    t.string "title"
    t.text "body"
    t.jsonb "data"
    t.boolean "broadcast"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "opening_hours", force: :cascade do |t|
    t.bigint "venue_id", null: false
    t.integer "day_of_week"
    t.time "opens_at"
    t.time "closes_at"
    t.boolean "closed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["venue_id"], name: "index_opening_hours_on_venue_id"
  end

  create_table "payments", force: :cascade do |t|
    t.string "payable_type", null: false
    t.bigint "payable_id", null: false
    t.bigint "user_id", null: false
    t.integer "amount_cents"
    t.string "currency"
    t.string "provider"
    t.string "provider_ref"
    t.integer "status"
    t.jsonb "raw"
    t.datetime "paid_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payable_type", "payable_id"], name: "index_payments_on_payable"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "race_entries", force: :cascade do |t|
    t.bigint "race_id", null: false
    t.bigint "driver_id"
    t.bigint "kart_type_id"
    t.integer "kart_number"
    t.string "transponder_id"
    t.integer "grid_position"
    t.integer "finish_position"
    t.integer "status"
    t.integer "best_lap_ms"
    t.integer "total_time_ms"
    t.integer "laps_completed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_race_entries_on_driver_id"
    t.index ["kart_type_id"], name: "index_race_entries_on_kart_type_id"
    t.index ["race_id"], name: "index_race_entries_on_race_id"
  end

  create_table "races", force: :cascade do |t|
    t.string "name"
    t.bigint "competition_id"
    t.bigint "track_id"
    t.integer "status"
    t.integer "race_type"
    t.datetime "scheduled_at"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.integer "total_laps"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["competition_id"], name: "index_races_on_competition_id"
    t.index ["track_id"], name: "index_races_on_track_id"
  end

  create_table "registrations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "registerable_type", null: false
    t.bigint "registerable_id", null: false
    t.bigint "driver_id"
    t.integer "status"
    t.string "reference"
    t.datetime "registered_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_registrations_on_driver_id"
    t.index ["reference"], name: "index_registrations_on_reference", unique: true
    t.index ["registerable_type", "registerable_id"], name: "index_registrations_on_registerable"
    t.index ["user_id"], name: "index_registrations_on_user_id"
  end

  create_table "session_prices", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.text "description"
    t.bigint "kart_type_id"
    t.integer "duration_minutes"
    t.integer "laps"
    t.integer "price_cents"
    t.string "currency"
    t.integer "category"
    t.integer "position"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kart_type_id"], name: "index_session_prices_on_kart_type_id"
    t.index ["slug"], name: "index_session_prices_on_slug", unique: true
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "membership_plan_id", null: false
    t.integer "status"
    t.datetime "started_at"
    t.datetime "ends_at"
    t.boolean "auto_renew"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["membership_plan_id"], name: "index_subscriptions_on_membership_plan_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "tournament_matches", force: :cascade do |t|
    t.bigint "competition_id", null: false
    t.integer "round"
    t.integer "slot"
    t.bigint "driver_a_id"
    t.bigint "driver_b_id"
    t.bigint "winner_id"
    t.string "score"
    t.datetime "scheduled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["competition_id"], name: "index_tournament_matches_on_competition_id"
    t.index ["driver_a_id"], name: "index_tournament_matches_on_driver_a_id"
    t.index ["driver_b_id"], name: "index_tournament_matches_on_driver_b_id"
    t.index ["winner_id"], name: "index_tournament_matches_on_winner_id"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.text "description"
    t.integer "length_m"
    t.integer "corners"
    t.string "surface"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_tracks_on_slug", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "locale", default: "fr", null: false
    t.boolean "marketing_opt_in", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "venues", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "address"
    t.string "city"
    t.string "country"
    t.string "postal_code"
    t.string "phone"
    t.string "email"
    t.decimal "latitude"
    t.decimal "longitude"
    t.jsonb "socials"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "best_laps", "drivers"
  add_foreign_key "best_laps", "kart_types"
  add_foreign_key "best_laps", "races"
  add_foreign_key "best_laps", "tracks"
  add_foreign_key "bookings", "kart_types"
  add_foreign_key "bookings", "session_prices"
  add_foreign_key "bookings", "users"
  add_foreign_key "championship_standings", "competitions"
  add_foreign_key "championship_standings", "drivers"
  add_foreign_key "competitions", "tracks"
  add_foreign_key "drivers", "users"
  add_foreign_key "laps", "race_entries"
  add_foreign_key "notifications", "users"
  add_foreign_key "opening_hours", "venues"
  add_foreign_key "payments", "users"
  add_foreign_key "race_entries", "drivers"
  add_foreign_key "race_entries", "kart_types"
  add_foreign_key "race_entries", "races"
  add_foreign_key "races", "competitions"
  add_foreign_key "races", "tracks"
  add_foreign_key "registrations", "drivers"
  add_foreign_key "registrations", "users"
  add_foreign_key "session_prices", "kart_types"
  add_foreign_key "subscriptions", "membership_plans"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "tournament_matches", "competitions"
  add_foreign_key "tournament_matches", "drivers", column: "driver_a_id"
  add_foreign_key "tournament_matches", "drivers", column: "driver_b_id"
  add_foreign_key "tournament_matches", "drivers", column: "winner_id"
end
