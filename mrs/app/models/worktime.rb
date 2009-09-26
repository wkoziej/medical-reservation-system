class Worktime < ActiveRecord::Base
  belongs_to :place
  belongs_to :doctor, :class_name => "User"
  DAYS_OF_WEEK = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
  REPETITIONS  = ["No", "EW", "E2W", "E3W", "EM"]
end
