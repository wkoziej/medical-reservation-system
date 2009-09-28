class CreateWorktimes < ActiveRecord::Migration
  def self.up
    create_table :worktimes do |t|
      t.datetime :since,                       :null => false
      t.datetime :until,                       :null => false
      t.integer :doctor_id,                    :null => false
      t.integer :place_id,                     :null => false
      t.integer  :day_of_week,                 :null => false 
      t.integer  :repetition,                   :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :worktimes
  end
end
