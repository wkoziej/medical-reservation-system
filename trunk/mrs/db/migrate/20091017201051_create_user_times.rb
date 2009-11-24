class CreateUserTimes < ActiveRecord::Migration
  def self.up
    create_table :user_times do |t|
      t.date :day
      t.integer :user_id
      t.timestamps
    end

    add_index :user_times, [:day, :user_id], :unique => true
    add_foreign_key(:user_times, :users, :column => "user_id")

  end

  def self.down
    drop_table :user_times
  end
end
