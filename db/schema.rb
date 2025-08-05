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

ActiveRecord::Schema[8.0].define(version: 2025_08_05_023921) do
  create_table "children", force: :cascade do |t|
    t.string "name", null: false
    t.string "theme", default: "default"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "task_completions", force: :cascade do |t|
    t.integer "task_id", null: false
    t.date "completed_on", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["completed_on"], name: "index_task_completions_on_completed_on"
    t.index ["task_id", "completed_on"], name: "index_task_completions_on_task_id_and_completed_on", unique: true
    t.index ["task_id"], name: "index_task_completions_on_task_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.integer "child_id", null: false
    t.string "name", null: false
    t.integer "time_of_day", default: 1
    t.string "frequency", default: "daily"
    t.string "specific_days"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 0, null: false
    t.index ["child_id", "active"], name: "index_tasks_on_child_id_and_active"
    t.index ["child_id", "time_of_day", "position", "name"], name: "index_tasks_on_child_id_and_time_of_day_and_position_and_name"
    t.index ["child_id"], name: "index_tasks_on_child_id"
    t.index ["time_of_day"], name: "index_tasks_on_time_of_day"
  end

  add_foreign_key "task_completions", "tasks"
  add_foreign_key "tasks", "children"
end
