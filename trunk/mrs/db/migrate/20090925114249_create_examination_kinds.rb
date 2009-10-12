class CreateExaminationKinds < ActiveRecord::Migration
  def self.up
    create_table :examination_kinds do |t|
      t.text :name
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :examination_kinds
  end

end
