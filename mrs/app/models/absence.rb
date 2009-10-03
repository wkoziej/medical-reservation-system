class Absence < ActiveRecord::Base
  belongs_to :doctor, :class_name => "User"

  def self.absences_at_day (doctor_id, day)
    Absence.find(:all, :conditions => [ " doctor_id = :doctor_id and ( :day between since and until or (since between :day and :next_day) or (until between :day and :next_day) ) ",
                                        { :doctor_id => doctor_id, :day => day, :next_day => (day + 1.days) }
                                      ])
  end

end
