class Visit < ActiveRecord::Base
  belongs_to :patient, :class_name => "User"
  belongs_to :doctor, :class_name => "User"
  belongs_to :visit_reservation
end
