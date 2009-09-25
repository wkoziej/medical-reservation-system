class DoctorSpeciality < ActiveRecord::Base
  belongs_to :doctor, :class_name => "User"
  belongs_to :speciality
end
