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

ActiveRecord::Schema.define(:version => 20090925212958) do

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
    t.string   "status",     :limit => 1
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
    t.datetime "since",                    :null => false
    t.datetime "until",                    :null => false
    t.integer  "doctor_id",                :null => false
    t.integer  "place_id",                 :null => false
    t.string   "day_of_week", :limit => 3, :null => false
    t.string   "repetition",  :limit => 3, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
