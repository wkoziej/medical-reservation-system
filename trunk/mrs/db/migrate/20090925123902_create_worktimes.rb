class CreateWorktimes < ActiveRecord::Migration
  def self.up
    create_table :worktimes do |t|
      t.date :start_date,                      :null => false
      t.date :end_date,                        :null => false
      t.time :since,                        :null => false # in minutes
      t.time :until,                        :null => false # in minutes
      t.integer :doctor_id,                    :null => false, :foreign_key => true
      t.integer :place_id,                     :null => false, :foreign_key => true
      t.integer  :repetition,                  :null => false
      t.timestamps
    end

    add_foreign_key(:worktimes, :places, :column => "place_id")
    add_foreign_key(:worktimes, :users, :column => "doctor_id")

  end

  def self.down
    drop_table :worktimes
  end

end
