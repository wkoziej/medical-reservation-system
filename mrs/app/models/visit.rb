class Visit < ActiveRecord::Base
  belongs_to :patient, :class_name => "User"
  belongs_to :doctor, :class_name => "User"
  belongs_to :visit_reservation

  include Period::Check
  include Period::Format
  include Period::Util

  validates_presence_of :until, :since, :patient, :doctor

  def validate 
    if not period_valid?
      errors.add("visit_time", "Visit period not valid")
    end

    if period_overlap?("doctor_id = :doctor_id", {:doctor_id => self.doctor_id}) 
      errors.add("visit_time", "There are visits wich overlap")
    end    

    if period_overlap?("patient_id = :patient_id", {:patient_id => self.patient_id}) 
      errors.add("visit_time", "There are visits wich overlap")
    end
    
    # check absences and visits at this time for this doctor
    if not Worktime.available?(self.since, self.until, self.doctor_id, nil, nil)
      errors.add("worktime_not_available", "Not available worktime - no doctor at this time")
    end
    
  end

  def visits_at_day (doctor_id, day)
    rows_at_day(day, "doctor_id = :doctor_id", {:doctor_id => doctor_id})
  end

end
