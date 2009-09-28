class CreateSpecialities < ActiveRecord::Migration
  def self.up
    create_table :specialities do |t|
      t.text :name
      t.timestamps
    end

    add_index :specialities, :name, :unique => true
    create_speciality ("Surgeon");
    create_speciality ("Paedatrican");
    create_speciality ("Dentist");
    create_speciality ("Dermatologist");   
    
  end

  def self.down
    drop_table :specialities
  end

private
  def self.create_speciality (name)
    speciality = Speciality.new
    speciality.name = name
    speciality.save
  end

end
