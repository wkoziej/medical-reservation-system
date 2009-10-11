class VisitReservation < ActiveRecord::Base

  acts_as_state_machine :initial => :OPEN, :column => 'status'

  belongs_to    :patient, :class_name => "User"
  belongs_to    :doctor , :class_name => "User" 

  state :OPEN
  state :CANCELED
  state :USED
  
  include Period::Util

  validates_presence_of :until, :since, :patient, :doctor
  
  def short_info
    patient.name + " " + since.strftime("%Y-%m-%d %H:%M")
  end

  # def self.reservations_at_day (doctor_id, day)
  #   VisitReservation.find(:all, :conditions => [ " status != :canceled and doctor_id = :doctor_id and ( :day between since and until or (since between :day and :next_day) ) " ,
  #                                                { :canceled => "CANCELED", :doctor_id => doctor_id, :day => day, :next_day => (day + 1.days) }
  #                                              ])
  # end

  def reservations_at_day (doctor_id, day)
    rows_at_day(day, "doctor_id = :doctor_id and status != :canceled", {:doctor_id => doctor_id, :canceled => "CANCELED"})
  end

  event :cancel do
    transitions :to => :CANCELED, :from => :OPEN
  end

  event :use do
    transitions :to => :USED, :from => :OPEN
  end

  event :reset do   
    transitions :to => :OPEN, :from => :USED, :guard => Proc.new {|o| o.since <= Date.today }
    transitions :to => :CANCELED, :from => :USED, :guard => Proc.new {|o| o.since > Date.today }
  end

end
