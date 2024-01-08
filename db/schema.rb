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

ActiveRecord::Schema[7.1].define(version: 2024_01_08_020900) do
  create_table "_litestream_lock", id: false, force: :cascade do |t|
    t.integer "id"
  end

  create_table "_litestream_seq", force: :cascade do |t|
    t.integer "seq"
  end

  create_table "dashboards", id: :string, force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", id: :string, force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "list_id"
    t.index ["list_id"], name: "index_items_on_list_id"
  end

  create_table "lists", id: :string, force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.integer "pointer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "dashboard_id"
    t.index ["dashboard_id"], name: "index_lists_on_dashboard_id"
  end

  create_table "timers", id: :string, force: :cascade do |t|
    t.datetime "last_ticked_at"
    t.datetime "next_tick_at"
    t.integer "trigger_day", null: false
    t.string "list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["list_id"], name: "index_timers_on_list_id"
  end

  add_foreign_key "timers", "lists"
end
