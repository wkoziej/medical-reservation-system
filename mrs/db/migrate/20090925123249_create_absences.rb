class CreateAbsences < ActiveRecord::Migration
  def self.up
    create_table :absences do |t|
      t.datetime :since
      t.datetime :until
      t.integer :doctor_id,                :null => false
      t.string  :couse,                    :limit => 256
      t.timestamps
    end
    add_index "absences", "doctor_id"
  end

  def self.down
    drop_table :absences
  end
end
