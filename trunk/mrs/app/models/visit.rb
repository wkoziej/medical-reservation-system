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
      add_period_error (:visit_period_not_valid)     
    end

    if period_overlap?("doctor_id = :doctor_id", {:doctor_id => self.doctor_id})
      add_period_error (:visit_time_overlap)     
    end    

    if period_overlap?("patient_id = :patient_id", {:patient_id => self.patient_id})
      add_period_error (:visit_time_overlap)     
    end
    
    # check absences and visits at this time for this doctor
    if not Worktime.available?(self.since, self.until, self.doctor_id, nil, nil)
      errors.add(:worktime, errors.generate_message(:worktime_not_available, :worktime_not_available_description))
    end
    
  end

  def visits_at_day (doctor_id, day)
    rows_at_day(day, "doctor_id = :doctor_id", {:doctor_id => doctor_id})
  end

end
