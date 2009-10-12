class CreateSpecialities < ActiveRecord::Migration
  def self.up
    create_table :specialities do |t|
      t.text :name
      t.timestamps
    end

    add_index :specialities, :name, :unique => true
    
  end

  def self.down
    drop_table :specialities
  end

private

end
