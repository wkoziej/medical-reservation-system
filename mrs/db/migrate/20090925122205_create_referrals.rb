class CreateReferrals < ActiveRecord::Migration
  def self.up
    create_table :referrals do |t|
      t.integer :patient_id,         :null => false
      t.integer :doctor_id,          :null => false
      t.integer :visit_id,           :null => true
      t.datetime :expire,            :null => false
      t.timestamps
    end
    add_index "referrals", "patient_id"
    add_index "referrals", "doctor_id"
    add_index "referrals", "visit_id"

    add_foreign_key(:referrals, :users, :column => "doctor_id")
    add_foreign_key(:referrals, :users, :column => "patient_id")
    add_foreign_key(:referrals, :visits, :column => "visit_id")


  end

  def self.down
    drop_table :referrals
  end
end
