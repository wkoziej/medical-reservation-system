class CreateSchedules < ActiveRecord::Migration
  def self.up
    create_table :schedules do |t|
      t.datetime :since
      t.datetime :until
        t.integer :doctor_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :schedules
  end
end
