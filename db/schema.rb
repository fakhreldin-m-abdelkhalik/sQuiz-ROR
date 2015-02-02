# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150202113137) do

  create_table "graph_managers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "graphs", force: true do |t|
    t.integer  "graph_manager_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "graphs", ["graph_manager_id"], name: "index_graphs_on_graph_manager_id"

  create_table "groups", force: true do |t|
    t.string   "name"
    t.integer  "instructor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["instructor_id"], name: "index_groups_on_instructor_id"

  create_table "groups_quizzes", id: false, force: true do |t|
    t.integer "group_id"
    t.integer "quiz_id"
  end

  add_index "groups_quizzes", ["group_id"], name: "index_groups_quizzes_on_group_id"
  add_index "groups_quizzes", ["quiz_id"], name: "index_groups_quizzes_on_quiz_id"

  create_table "groups_students", id: false, force: true do |t|
    t.integer "group_id"
    t.integer "student_id"
  end

  add_index "groups_students", ["group_id"], name: "index_groups_students_on_group_id"
  add_index "groups_students", ["student_id"], name: "index_groups_students_on_student_id"

  create_table "instructors", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
  end

  add_index "instructors", ["authentication_token"], name: "index_instructors_on_authentication_token", unique: true
  add_index "instructors", ["email"], name: "index_instructors_on_email", unique: true
  add_index "instructors", ["reset_password_token"], name: "index_instructors_on_reset_password_token", unique: true

  create_table "questions", force: true do |t|
    t.text     "text"
    t.float    "mark"
    t.text     "choices"
    t.string   "right_answer"
    t.integer  "quiz_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["quiz_id"], name: "index_questions_on_quiz_id"

  create_table "quizzes", force: true do |t|
    t.string   "name"
    t.string   "subject"
    t.integer  "duration"
    t.integer  "no_of_MCQ"
    t.integer  "no_of_rearrangeQ"
    t.integer  "instructor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quizzes", ["instructor_id"], name: "index_quizzes_on_instructor_id"

  create_table "student_result_quizzes", force: true do |t|
    t.float    "result"
    t.integer  "quiz_id"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "student_result_quizzes", ["quiz_id"], name: "index_student_result_quizzes_on_quiz_id"
  add_index "student_result_quizzes", ["student_id"], name: "index_student_result_quizzes_on_student_id"

  create_table "students", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
  end

  add_index "students", ["authentication_token"], name: "index_students_on_authentication_token", unique: true
  add_index "students", ["email"], name: "index_students_on_email", unique: true
  add_index "students", ["reset_password_token"], name: "index_students_on_reset_password_token", unique: true

end
