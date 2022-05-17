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

ActiveRecord::Schema[7.0].define(version: 2022_05_14_105822) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "captions", force: :cascade do |t|
    t.string "url"
    t.string "text", default: ""
    t.string "caption_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "instagram_captions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "content_type"
    t.string "url"
    t.string "text", default: ""
    t.string "caption_url"
    t.string "filter"
    t.string "color"
    t.string "start_color"
    t.string "end_color"
  end

  create_table "tokens", force: :cascade do |t|
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "users_id"
    t.index ["users_id"], name: "index_tokens_on_users_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end 
