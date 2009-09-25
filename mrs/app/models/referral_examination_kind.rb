class ReferralExaminationKind < ActiveRecord::Base
  belongs_to :referral
  belongs_to :examination_kind
end
