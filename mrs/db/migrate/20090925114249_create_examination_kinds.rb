class CreateExaminationKinds < ActiveRecord::Migration
  def self.up
    create_table :examination_kinds do |t|
      t.text :name
      t.text :description

      t.timestamps
    end
    create_examination_kind("Hemanalysis")
    create_examination_kind("OB")
    create_examination_kind("Urine test")
  end

  def self.down
    drop_table :examination_kinds
  end

private

  def self.create_examination_kind(name)
    kind = ExaminationKind.new
    kind.name = name
    kind.save
  end
end
