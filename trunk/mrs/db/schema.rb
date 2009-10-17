# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091017201051) do

  create_table "absences", :force => true do |t|
    t.datetime "since"
    t.datetime "until"
    t.integer  "doctor_id",                 :null => false
    t.string   "couse",      :limit => 256
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "absences", ["doctor_id"], :name => "index_absences_on_doctor_id"

  create_table "doctor_specialities", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "doctor_id",     :null => false
    t.integer  "speciality_id", :null => false
    t.datetime "since",         :null => false
  end

  add_index "doctor_specialities", ["doctor_id", "speciality_id"], :name => "index_doctor_specialities_on_speciality_id_and_doctor_id", :unique => true
  add_index "doctor_specialities", ["doctor_id"], :name => "index_doctor_specialities_on_doctor_id"
  add_index "doctor_specialities", ["speciality_id"], :name => "index_doctor_specialities_on_speciality_id"

  create_table "examination_kinds", :force => true do |t|
    t.text     "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "examinations", :force => true do |t|
    t.integer  "patient_id",          :null => false
    t.integer  "examination_kind_id", :null => false
    t.integer  "doctor_id",           :null => false
    t.integer  "visit_id"
    t.datetime "execution_date",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "places", :force => true do |t|
    t.text     "name"
    t.text     "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "places", ["name"], :name => "index_places_on_name", :unique => true

  create_table "referral_examination_kinds", :force => true do |t|
    t.integer  "referral_id",         :null => false
    t.integer  "examination_kind_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "referrals", :force => true do |t|
    t.integer  "patient_id", :null => false
    t.integer  "doctor_id",  :null => false
    t.integer  "visit_id"
    t.datetime "expire",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "referrals", ["doctor_id"], :name => "index_referrals_on_doctor_id"
  add_index "referrals", ["patient_id"], :name => "index_referrals_on_patient_id"
  add_index "referrals", ["visit_id"], :name => "index_referrals_on_visit_id"

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "specialities", :force => true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "specialities", ["name"], :name => "index_specialities_on_name", :unique => true

  create_table "user_times", :force => true do |t|
    t.date     "day"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_times", ["day", "user_id"], :name => "index_user_times_on_day_and_user_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                    :default => "passive"
    t.datetime "deleted_at"
    t.string   "type",                      :limit => 20,  :default => "User"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "visit_reservations", :force => true do |t|
    t.datetime "since"
    t.datetime "until"
    t.string   "status",     :limit => 8, :null => false
    t.integer  "patient_id",              :null => false
    t.integer  "doctor_id",               :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "visit_reservations", ["doctor_id"], :name => "index_visit_reservations_on_doctor_id"
  add_index "visit_reservations", ["patient_id"], :name => "index_visit_reservations_on_patient_id"

  create_table "visits", :force => true do |t|
    t.datetime "since"
    t.datetime "until"
    t.text     "note"
    t.integer  "patient_id",           :null => false
    t.integer  "doctor_id",            :null => false
    t.integer  "visit_reservation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "worktimes", :force => true do |t|
    t.date     "start_date", :null => false
    t.date     "end_date",   :null => false
    t.time     "since",      :null => false
    t.time     "until",      :null => false
    t.integer  "doctor_id",  :null => false
    t.integer  "place_id",   :null => false
    t.integer  "repetition", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "absences", "users", :name => "absences_doctor_id_fk", :column => "doctor_id"

  add_foreign_key "doctor_specialities", "specialities", :name => "doctor_specialities_speciality_id_fk"
  add_foreign_key "doctor_specialities", "users", :name => "doctor_specialities_doctor_id_fk", :column => "doctor_id"

  add_foreign_key "examinations", "examination_kinds", :name => "examinations_examination_kind_id_fk"
  add_foreign_key "examinations", "users", :name => "examinations_doctor_id_fk", :column => "doctor_id"
  add_foreign_key "examinations", "users", :name => "examinations_patient_id_fk", :column => "patient_id"
  add_foreign_key "examinations", "visits", :name => "examinations_visit_id_fk"

  add_foreign_key "referral_examination_kinds", "examination_kinds", :name => "referral_examination_kinds_examination_kind_id_fk"
  add_foreign_key "referral_examination_kinds", "referrals", :name => "referral_examination_kinds_referral_id_fk"

  add_foreign_key "referrals", "users", :name => "referrals_doctor_id_fk", :column => "doctor_id"
  add_foreign_key "referrals", "users", :name => "referrals_patient_id_fk", :column => "patient_id"
  add_foreign_key "referrals", "visits", :name => "referrals_visit_id_fk"

  add_foreign_key "user_times", "users", :name => "user_times_user_id_fk"

  add_foreign_key "visit_reservations", "users", :name => "visit_reservations_doctor_id_fk", :column => "doctor_id"
  add_foreign_key "visit_reservations", "users", :name => "visit_reservations_patient_id_fk", :column => "patient_id"

  add_foreign_key "visits", "users", :name => "visits_doctor_id_fk", :column => "doctor_id"
  add_foreign_key "visits", "users", :name => "visits_patient_id_fk", :column => "patient_id"
  add_foreign_key "visits", "visit_reservations", :name => "visits_visit_reservation_id_fk"

  add_foreign_key "worktimes", "places", :name => "worktimes_place_id_fk"
  add_foreign_key "worktimes", "users", :name => "worktimes_doctor_id_fk", :column => "doctor_id"

end
