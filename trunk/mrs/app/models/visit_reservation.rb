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
    if not period_valid?
      errors.add("visit_reservation_time", "Visit reservation period not valid")
    end
    if period_overlap?("doctor_id = :doctor_id", {:doctor_id => self.doctor_id})
      errors.add("visit_reservation_time", "Visit reservation time overlap")
    end
    if period_overlap?("patient_id = :patient_id", {:patient_id => self.patient_id})
      errors.add("visit_reservation_time", "Visit reservation time overlap")
    end

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
