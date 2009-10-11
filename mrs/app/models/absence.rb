class Absence < ActiveRecord::Base
  belongs_to :doctor, :class_name => "User"

  include Period::Check
  include Period::Util
  
  def validate
    if not period_valid?
      errors.add("absence_time", "Absence period not valid")
    end
    if period_overlap?("doctor_id = :doctor_id", {:doctor_id => self.doctor_id})
      errors.add("absence_time", "Absence time overlap")
    end
  end
  
  def absences_at_day (doctor_id, day)
    rows_at_day(day, "doctor_id = :doctor_id", {:doctor_id => doctor_id})
  end

end
