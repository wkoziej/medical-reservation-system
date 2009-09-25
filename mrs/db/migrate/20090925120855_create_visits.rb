class CreateVisits < ActiveRecord::Migration
  def self.up
    create_table :visits do |t|
      t.datetime :since
      t.datetime :until
      t.text :note
      t.integer  :patient_id, :null => false
      t.integer  :doctor_id, :null => false
      t.integer  :visit_reservation_id, :null => true
      t.timestamps
    end
  end

  def self.down
    drop_table :visits
  end
end
