class Absence < ActiveRecord::Base
  belongs_to :doctor, :class_name => "User"
end
