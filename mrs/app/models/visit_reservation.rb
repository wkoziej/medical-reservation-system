class VisitReservation < ActiveRecord::Base
  belongs_to    :patient, :class_name => "User"
  belongs_to    :doctor , :class_name => "User" 

  
  STATUS = {:NEW => "New", :CANCELED => "Canceled", :RUNNING => "Running", :DONE => "Done", :MISSED => "Missed"}

  validates_presence_of :until, :since, :patient, :doctor, :status
  
  def short_info
    patient.name + " " + since.to_s
  end

  def self.reservations_at_day (doctor_id, day)
    VisitReservation.find(:all, :conditions => [ " doctor_id = :doctor_id and ( :day between since and until or (since between :day and :next_day) ) " ,
                                                 { :doctor_id => doctor_id, :day => day, :next_day => (day + 1.days) }
                                               ])
  end

end
