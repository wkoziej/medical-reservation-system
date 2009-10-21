class VisitReservation < ActiveRecord::Base

  acts_as_state_machine :initial => :OPEN, :column => 'status'

  belongs_to    :patient, :class_name => "User"
  belongs_to    :doctor , :class_name => "User" 

  state :OPEN
  state :CANCELED
  state :CLOSED
  
  include Period::Util
  include Period::Check

  validates_presence_of :until, :since, :patient, :doctor

  
  def validate

    # Insert row into user_times to ensure resoure available for one
    # process, see rescure section
    user_time = UserTime.new({:user_id => self.doctor_id, :day => self.since.to_date})
    user_time.save   
    
    if not period_valid?      
      add_period_error (:visit_reservation_period_not_valid)      
    end

    if period_overlap?("doctor_id = :doctor_id", {:doctor_id => self.doctor_id})
      add_period_error (:visit_reservation_time_overlap)     
    end
    
    if period_overlap?("patient_id = :patient_id", {:patient_id => self.patient_id})
      add_period_error (:visit_reservation_time_overlap)     
    end    
    # check absences and visits at this time for this doctor
    if not Worktime.available?(self.since, self.until, self.doctor_id, nil, nil)
      errors.add(:reservation_time, errors.generate_message(:reservation_time, :worktime_not_available_description))
    end

  rescue ActiveRecord::StatementInvalid => error
    errors.add(:resource_locked, errors.generate_message(:resource_locked, :resource_locked_description))    
  end

  # Release lock
  def after_save
    user_time = UserTime.find_by_user_id_and_day(self.doctor_id, self.since.to_date)
    user_time.destroy
  end
  
  def short_info
    patient.name + " " + since.strftime("%Y-%m-%d %H:%M")
  end

  def reservations_at_day (doctor_id, day)
    rows_at_day(day, "doctor_id = :doctor_id and status != :canceled", {:doctor_id => doctor_id, :canceled => "CANCELED"})
  end

  event :cancel do
    transitions :to => :CANCELED, :from => :OPEN
  end

  event :use do
    transitions :to => :CLOSED, :from => :OPEN
  end

  event :reset do   
    transitions :to => :OPEN, :from => :CLOSED, :guard => Proc.new {|o| o.since <= Date.today }
    transitions :to => :CANCELED, :from => :CLOSED, :guard => Proc.new {|o| o.since > Date.today }
  end

end
