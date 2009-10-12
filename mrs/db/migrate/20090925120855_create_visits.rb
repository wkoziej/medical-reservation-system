class CreateVisits < ActiveRecord::Migration
  def self.up
    create_table :visits do |t|
      t.datetime :since
      t.datetime :until
      t.text :note
      t.integer  :patient_id, :null => false
      t.integer  :doctor_id, :null => false
      t.integer  :visit_reservation_id, :null => true, :foreign_key => true
      t.timestamps
      
    end
    add_foreign_key(:visits, :users, :column => "doctor_id")
    add_foreign_key(:visits, :users, :column => "patient_id")
    add_foreign_key(:visits, :visit_reservations, :column => "visit_reservation_id")
  end

  def self.down
    drop_table :visits
  end
end
