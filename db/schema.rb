# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180501175105) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "class_groups", force: :cascade do |t|
    t.string "class_name"
    t.string "course_name"
    t.string "class_description"
    t.integer "unique_id"
    t.bigint "lecturer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lecturer_id"], name: "index_class_groups_on_lecturer_id"
  end

  create_table "class_sessions", force: :cascade do |t|
    t.bigint "class_groups_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["class_groups_id"], name: "index_class_sessions_on_class_groups_id"
  end

  create_table "lecturers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "institute"
    t.bigint "users_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["users_id"], name: "index_lecturers_on_users_id"
  end

  create_table "student_classgroups", id: false, force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "class_group_id"
    t.index ["class_group_id"], name: "index_student_classgroups_on_class_group_id"
    t.index ["student_id"], name: "index_student_classgroups_on_student_id"
  end

  create_table "student_responses", force: :cascade do |t|
    t.bigint "students_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["students_id"], name: "index_student_responses_on_students_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.bigint "users_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["users_id"], name: "index_students_on_users_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.boolean "is_admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "class_groups", "lecturers"
  add_foreign_key "class_sessions", "class_groups", column: "class_groups_id"
  add_foreign_key "lecturers", "users", column: "users_id"
  add_foreign_key "student_responses", "students", column: "students_id"
  add_foreign_key "students", "users", column: "users_id"
end
