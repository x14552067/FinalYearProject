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

ActiveRecord::Schema.define(version: 20180509215401) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answermessages", force: :cascade do |t|
    t.bigint "classsession_id"
    t.bigint "lecturer_id"
    t.bigint "questionmessage_id"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["classsession_id"], name: "index_answermessages_on_classsession_id"
    t.index ["lecturer_id"], name: "index_answermessages_on_lecturer_id"
    t.index ["questionmessage_id"], name: "index_answermessages_on_questionmessage_id"
  end

  create_table "chatmessages", force: :cascade do |t|
    t.bigint "classsession_id"
    t.bigint "student_id"
    t.bigint "lecturer_id"
    t.string "content"
    t.boolean "is_anon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["classsession_id"], name: "index_chatmessages_on_classsession_id"
    t.index ["lecturer_id"], name: "index_chatmessages_on_lecturer_id"
    t.index ["student_id"], name: "index_chatmessages_on_student_id"
  end

  create_table "classgroups", force: :cascade do |t|
    t.string "class_name"
    t.string "course_name"
    t.string "class_description"
    t.integer "enrollment_key"
    t.integer "image_id"
    t.bigint "lecturer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lecturer_id"], name: "index_classgroups_on_lecturer_id"
  end

  create_table "classgroups_students", id: false, force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "classgroup_id", null: false
    t.index ["classgroup_id", "student_id"], name: "index_classgroups_students_on_classgroup_id_and_student_id"
    t.index ["student_id", "classgroup_id"], name: "index_classgroups_students_on_student_id_and_classgroup_id"
  end

  create_table "classsessions", force: :cascade do |t|
    t.bigint "classgroup_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "topic"
    t.integer "session_key"
    t.boolean "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["classgroup_id"], name: "index_classsessions_on_classgroup_id"
  end

  create_table "classsessions_students", id: false, force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "classsession_id", null: false
    t.index ["classsession_id", "student_id"], name: "index_classsessions_students_on_classsession_id_and_student_id"
    t.index ["student_id", "classsession_id"], name: "index_classsessions_students_on_student_id_and_classsession_id"
  end

  create_table "enrollments", force: :cascade do |t|
    t.integer "enrollment_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "joinsessions", force: :cascade do |t|
    t.integer "session_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lecturers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "institute"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_lecturers_on_user_id"
  end

  create_table "questionmessages", force: :cascade do |t|
    t.bigint "classsession_id"
    t.bigint "student_id"
    t.string "content"
    t.boolean "is_anon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["classsession_id"], name: "index_questionmessages_on_classsession_id"
    t.index ["student_id"], name: "index_questionmessages_on_student_id"
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
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_students_on_user_id"
  end

  create_table "understanding_polls", force: :cascade do |t|
    t.bigint "classsession_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["classsession_id"], name: "index_understanding_polls_on_classsession_id"
  end

  create_table "understanding_responses", force: :cascade do |t|
    t.boolean "understood"
    t.bigint "understanding_poll_id"
    t.bigint "student_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_understanding_responses_on_student_id"
    t.index ["understanding_poll_id"], name: "index_understanding_responses_on_understanding_poll_id"
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
    t.boolean "is_admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "answermessages", "classsessions"
  add_foreign_key "answermessages", "lecturers"
  add_foreign_key "answermessages", "questionmessages"
  add_foreign_key "chatmessages", "classsessions"
  add_foreign_key "chatmessages", "lecturers"
  add_foreign_key "chatmessages", "students"
  add_foreign_key "classgroups", "lecturers"
  add_foreign_key "classsessions", "classgroups"
  add_foreign_key "lecturers", "users"
  add_foreign_key "questionmessages", "classsessions"
  add_foreign_key "questionmessages", "students"
  add_foreign_key "student_responses", "students", column: "students_id"
  add_foreign_key "students", "users"
  add_foreign_key "understanding_polls", "classsessions"
end
