class CreateDoctorSpecialities < ActiveRecord::Migration
  def self.up
    create_table :doctor_specialities do |t|
      t.timestamps
      t.column          :doctor_id,            :integer, :null => false
      t.column          :speciality_id,        :integer, :null => false
      t.datetime        :since,                          :null => false
    end

    add_index "doctor_specialities", "doctor_id"
    add_index "doctor_specialities", "speciality_id"
  end

  def self.down
    drop_table :doctor_specialities
  end
end
