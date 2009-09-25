class Worktime < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :place
end
