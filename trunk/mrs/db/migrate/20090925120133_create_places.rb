class CreatePlaces < ActiveRecord::Migration
  def self.up
    create_table :places do |t|
      t.text :name
      t.text :address
      t.timestamps
    end
    
    add_index :places, :name, :unique => true

  end

  def self.down
    drop_table :places
  end

private

end
