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
  end

  def self.down
    drop_table :examinations
  end
end
