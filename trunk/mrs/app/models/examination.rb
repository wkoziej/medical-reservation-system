class Examination < ActiveRecord::Base
  belongs_to :patient
  belongs_to :doctor
  belongs_to :visit
  belongs_to :examination_kind
end
