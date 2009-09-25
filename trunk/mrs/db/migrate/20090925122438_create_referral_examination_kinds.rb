class CreateReferralExaminationKinds < ActiveRecord::Migration
  def self.up
    create_table :referral_examination_kinds do |t|
      t.integer :referral_id,                 :null => false
      t.integer :examination_kind_id,         :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :referral_examination_kinds
  end
end
