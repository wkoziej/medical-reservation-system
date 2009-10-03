class Worktime < ActiveRecord::Base
  belongs_to :place
  belongs_to :doctor, :class_name => "User"
  
  ONCE = 0
  EVERY_WEEK = 1
  EVERY_2_WEEKS = 2
  EVERY_MONTH_DAY = 3
  EVERY_DAY_OF_WEEK_IN_MONTH = 4

#  DAYS_OF_WEEK = [["Mon", 0], ["Tue", 1], ["Wed", 2], ["Thu", 3], ["Fri", 4], ["Sat", 5], ["Sun", 0]]

  REPETITIONS  = [
                  ["No repetition", ONCE], 
                  ["Every week", EVERY_WEEK], 
                  ["Every two weeks",EVERY_2_WEEKS], 
                  ["At this day (e.g 12) once in month", EVERY_MONTH_DAY],
                  ["At this day of week (e.g monday) once in month", EVERY_DAY_OF_WEEK_IN_MONTH]
                 ]

  def validate
    if since > self.until or start_date > end_date
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

  def formate_since
    t = since.hour.to_s + ":" + since.min.to_s
  end

  def formate_until
    t = self.until.hour.to_s + ":" + self.until.min.to_s
  end

  #  Example of evaluation:
  # 
  #  Absences in day                       Minutes from 00:00
  #  10:20 - 11:30    (1:10)    -> 70      10*60+20 - 11*60+30
  #
  #  Visits reservations
  #  8:00  - 8:30     (0:30)    -> 30      8 *60       8*60+30
  #  12:45 - 13:00    (0:15)    -> 15      12*60+45   13*60 
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
  # see worktime_test.rb
  def not_reserved_hours(day)
    return [] unless day_in_repetition?(day)

    absences = Absence.absences_at_day(doctor.id, day)
    reservations = VisitReservation.reservations_at_day(doctor.id, day)    

    logger.info " -          -- - - - -- -    - - -  - -  "
    # make array [[start, stop], ...]
    # from abcenses ...    
    exclusions = absences.collect { |a| logger.info (a.since.to_date < day.to_date ? 0 : day_minutes(a.since.to_time) ).to_s
      logger.info (a.until.to_date > day.to_date ? 24 * 60 : day_minutes(a.until.to_time) ).to_s
      logger.info a.since.to_date 
      logger.info a.until.to_date
      logger.info day
      [ a.since.to_date < day.to_date ? 0 : day_minutes(a.since.to_time) ,
        a.until.to_date > day.to_date ? 24 * 60 : day_minutes(a.until.to_time) 
      ] 
    }
    logger.info exclusions.class
    # ... and from reservations
    exclusions.concat reservations.collect { |a| [ a.since.to_date < day.to_date ? 0 : day_minutes(a.since.to_time) ,a.until.to_date > day.to_date ? 24 * 60 : day_minutes(a.until.to_time) ] }
    logger.info " ================ EXCLUSIONS ===== "
    logger.info exclusions.each {|e|  logger.info "[" + e[0].to_s + ", " + e[1].to_s + "]" }
    logger.info " ================ DAY_MINUTES SINCE, UNTIL ===== "
    logger.info day_minutes(self.since.to_time).to_s + ", " + day_minutes(self.until).to_s
    
    a = available_periods( day_minutes(self.since.to_time), day_minutes(self.until), exclusions)      
    logger.info "================ AVAILALBE ======"
    logger.info a
    a
  end
  
  # Return true if day is one of worktime repetition
  def day_in_repetition?(day)
    logger.info ">>>>>>>>>>>>>>>>>>> day_in_repetition? " + self.repetition.to_s + " " + Worktime::EVERY_WEEK.to_s
    if day.to_date < self.start_date or day.to_date > self.end_date
      logger.info " ===== RANGE !!! ===== "
      false
    else
      if self.repetition == Worktime::ONCE then
        day.to_date == self.start_date
      elsif self.repetition == Worktime::EVERY_WEEK 
        day.to_date.wday == self.start_date.wday
      elsif self.repetition == Worktime::EVERY_2_WEEKS 
        (day.to_date.yday - self.start_date.to_date.yday) % 14 == 0
      elsif self.repetition == Worktime::EVERY_MONTH_DAY
        day.to_date.mday == self.start_date.mday 
      elsif self.repetition == Worktime::EVERY_DAY_OF_WEEK_IN_MONTH
        # E.g. every second friday in month 
        wday = self.start_date.wday
        mday = self.start_date.mday
        which = mday / 7
        day.to_date.wday == wday and day.to_date.mday / 7 == which
      else
        false
      end
    end
  end


  # Returns table of periods from start to stop without exclusions
  # start - minutes from day start
  # stop - minutes from day start
  # exclusions - table with pairs [start, stop]
  def available_periods(start, stop, exclusions)
    if exclusions.count == 0 
      [[start, stop]]
    elsif start == stop
      []
    else
      a = []
      exclusions.sort!
      #for i in (0..(exclusions.count-1))
      i = 0
      e_count = exclusions.count
      while i < e_count
        e = exclusions[i]
        if e[0] <= start 
          start = e[1] < start ? start : e[1]
          i = i + 1
        else
          a << [start, e[0] > stop ? stop : e[0]]
          if e[1] > stop 
            start = stop # To prevent last array enlarging (*)
            break
          else
            start = e[1]
          end
        end
      end
      # (*)
      if start < stop
        a << [start, stop]
      end
      a
    end
  end
  
  def day_minutes(date)
    date.to_time.hour * 60 + date.to_time.min
  end

  def format_day_minutes_range(minutes_range)
    s = minutes_range [0]
    e = minutes_range [1]
    (s / 60).to_s + ":" + (s % 60).to_s + ".." + (e / 60).to_s + ":" + (e % 60).to_s
  end
end
