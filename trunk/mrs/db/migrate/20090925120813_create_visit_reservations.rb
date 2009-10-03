class CreateVisitReservations < ActiveRecord::Migration
  def self.up
    create_table :visit_reservations do |t|
      t.datetime :since
      t.datetime :until
      t.string :status,              :limit => 8,  :null => false
      t.integer :patient_id,                       :null => false
      t.integer :doctor_id,                        :null => false
      t.timestamps
    end

    add_index "visit_reservations", "patient_id"
    add_index "visit_reservations", "doctor_id"


  end

  def self.down
    drop_table :visit_reservations
  end
end
