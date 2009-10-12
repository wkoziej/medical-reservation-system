class CreateVisitReservations < ActiveRecord::Migration
  def self.up
    create_table :visit_reservations do |t|
      t.datetime :since
      t.datetime :until
      t.string   :status,              :limit => 8,  :null => false
      t.integer :patient_id,                       :null => false, :foreign_key => true
      t.integer :doctor_id,                        :null => false, :foreign_key => true
      t.timestamps
    end

    add_index "visit_reservations", "patient_id"
    add_index "visit_reservations", "doctor_id"

    add_foreign_key(:visit_reservations, :users, :column => "doctor_id")
    add_foreign_key(:visit_reservations, :users, :column => "patient_id")

  end

  def self.down
    drop_table :visit_reservations
  end
end
