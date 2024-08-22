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

ActiveRecord::Schema[7.2].define(version: 2024_08_22_120455) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "solid_cache_entries", force: :cascade do |t|
    t.binary "key", null: false
    t.binary "value", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_solid_cache_entries_on_key", unique: true
  end

  create_table "stations", force: :cascade do |t|
    t.string "name"
    t.text "url"
    t.integer "position", default: 100
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.string "country"
    t.string "browser_info_byuuid"
    t.text "logo_url"
    t.string "homepage"
    t.string "radiobox"
    t.boolean "ignore_tracks_from_stream", default: false, null: false
    t.boolean "change_track_info_order", default: false, null: false
    t.index ["position"], name: "index_stations_on_position"
  end
end
