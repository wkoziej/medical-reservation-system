class Absence < ActiveRecord::Base
  belongs_to :doctor, :class_name => "User"

  include Period::Check
  include Period::Util

  validates_presence_of :couse
  
  def validate
    if not period_valid?
      add_period_error (:absence_period_not_valid)     
    end
    if period_overlap?("doctor_id = :doctor_id", {:doctor_id => self.doctor_id})
      add_period_error (:absence_time_overlap)     
    end
  end
  
  def absences_at_day (doctor_id, day)
    rows_at_day(day, "doctor_id = :doctor_id", {:doctor_id => doctor_id})
  end

end
