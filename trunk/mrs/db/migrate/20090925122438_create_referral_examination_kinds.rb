class CreateReferralExaminationKinds < ActiveRecord::Migration
  def self.up
    create_table :referral_examination_kinds do |t|
      t.integer :referral_id,                 :null => false, :foreign_key => true
      t.integer :examination_kind_id,         :null => false, :foreign_key => true
      t.timestamps
    end

    add_foreign_key(:referral_examination_kinds, :referrals, :column => "referral_id")
    add_foreign_key(:referral_examination_kinds, :examination_kinds, :column => "examination_kind_id")
  end

  def self.down
    drop_table :referral_examination_kinds
  end
end
