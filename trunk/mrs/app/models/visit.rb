class Visit < ActiveRecord::Base
  belongs_to :patient, :class_name => "User"
  belongs_to :doctor, :class_name => "User"
  belongs_to :visit_reservation

  include Period::Check
  include Period::Format
  
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
  end

end
