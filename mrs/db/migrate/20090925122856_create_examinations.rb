class CreateExaminations < ActiveRecord::Migration
  def self.up
    create_table :examinations do |t|
      t.integer :patient_id,                 :null => false
      t.integer :examination_kind_id,        :null => false
      t.integer :doctor_id,                  :null => false
      t.integer :visit_id,                   :null => true
      t.datetime :execution_date,            :null => false
      t.timestamps
    end

    add_foreign_key(:examinations, :users, :column => "patient_id")
    add_foreign_key(:examinations, :users, :column => "doctor_id")
    add_foreign_key(:examinations, :examination_kinds, :column => "examination_kind_id")
    add_foreign_key(:examinations, :visits, :column => "visit_id")
 

  end

  def self.down
    drop_table :examinations
  end
end
