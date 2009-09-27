class VisitReservation < ActiveRecord::Base
  belongs_to    :patient, :class_name => "User"
  belongs_to    :doctor , :class_name => "User" 

  def self.reservations_for_day (doctor_id, day)
    VisitReservation.find(:all, :conditions => [ " doctor_id = :doctor_id and ( :day between since and until or (since between :day and :next_day) ) " ,
                                                 { :doctor_id => doctor_id, :day => day, :next_day => (day + 1.days) }
                                               ])
  end

end
