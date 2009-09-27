class Worktime < ActiveRecord::Base
  belongs_to :place
  belongs_to :doctor, :class_name => "User"
  
  ONCE = 0
  EVERY_WEEK = 1
  EVERY_2_WEEKS = 2
  EVERY_MONTH_DAY = 3
  EVERY_DAY_OF_WEEK_IN_MONTH = 4

  DAYS_OF_WEEK = [["Mon", 0], ["Tue", 1], ["Wed", 2], ["Thu", 3], ["Fri", 4], ["Sat", 5], ["Sun", 0]]
  REPETITIONS  = [
                  ["No repetition", ONCE], 
                  ["Every week", EVERY_WEEK], 
                  ["Every two weeks",EVERY_2_WEEKS], 
                  ["At this day (e.g 12) once in month", EVERY_MONTH_DAY],
                  ["At this day of week (e.g monday) once in month", EVERY_DAY_OF_WEEK_IN_MONTH]
                 ]

  def validate
    if since > self.until 
        errors.add("since_or_until", "since has to be less then until") 
#      errors.add("until", "until has to be greater then since") 
    end

    if since == self.until 
      b = since.hour > self.until.hour 
      c = since.hour == self.until.hour and since.min > self.until.min
      if  b or c
        errors.add("since_or_until", "since has to be less then until") 
 #       errors.add("until", "until has to be greater then since") 
      end
    end
  end
  
  def validate_on_create # is only run the first time a new object is saved
  end
  
  def validate_on_update  
  end
  
  def date_from 
    since.to_date
  end

  def date_to
    self.until.to_date
  end
  
  def time_period_in_minutes
    t = (self.until.hour - since.hour) * 60 + (self.until.min - since.min)
    if t < 0 
      t = (self.until.hour + 24 - since.hour) * 60 + (self.until.min + 60 - since.min)
    end
    t
  end

  def formated_time_period
    t = time_period_in_minutes
    (t / 60).to_s + ":" + (t % 60).to_s
  end

  #  Example of evaluation:
  # 
  #  Absences in day                       Minutes from 00:00
  #  10:20 - 11:30    (1:10)    -> 70      10*60+20 - 11*60+30
  #
  #  Visits reservations
  #  8:00  - 8:30     (0:30)    -> 30
  #  12:45 - 13:00    (0:15)    -> 15
  #  
  #  Worktime
  #  8:00  - 16:00    (8:00)    -> 480
  #
  #  Not reserved hours
  #  8:30  - 10:20    (1:50)    -> 110
  #  11:30 - 12:45    (1:15)    -> 75
  #  13:00 - 16:00    (3:00)    -> 180
  #
  #         480-(70+30+15) = 110+75+180   //  365=365
  #
  # Return data format [[start of period in minutes from 00:00, end of period in minutes from 00:00], ...]
  # data for above example:
  # [ [8*60+30, 10*60+20], [11*60+30, 12*60+45], [13*60, 16*60]]
  def not_reserved_hours(day)

    absences = Absence.absences_for_day (doctor.id, day)
    reservations = VisitReservation.reservations_for_day (doctor.id, day)    
    
    if self.repetition == ONCE then
      if day.yday == self.since.yday then        
        #### time_period_in_minutes - visits_reservations - absences
        #        available_periods( day_minutes (self.since.to_time), day_minutes (self.until),                           
        #                           )
      end
    elsif  self.repetition == EVERY_WEEK then
    elsif day.day == self.since.day 
    end
    []
  end
  
  # Returns table of periods from start to stop without exclusions
  # start - minutes from day start
  # stop - minutes from day start
  # exclusions - table with pairs [start, stop]
  def available_periods (start, stop, exclusions)
    
  end

  def day_minutes (date)
    date.to_time.hour * 60 + date.to_time.min
  end

end
