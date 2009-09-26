class CreatePlaces < ActiveRecord::Migration
  def self.up
    create_table :places do |t|
      t.text :name
      t.text :address
      t.timestamps
    end
    
    add_index :name, :unique => true

    create_place("Lublin", "Batorego 11")
    create_place("Krakow", "Sieczki 33")
    create_place("Warszawa", "Szara 1/A")
  end

  def self.down
    drop_table :places
  end

private
  def self.create_place(name, address)
    place = Place.new
    place.name = name
    place.address = address
    place.save
  end

end
