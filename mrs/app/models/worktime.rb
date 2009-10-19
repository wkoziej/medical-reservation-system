class Worktime < ActiveRecord::Base
  belongs_to :place
  belongs_to :doctor, :class_name => "User"

  validates_presence_of :until, :since, :doctor, :start_date, :end_date, :repetition  
  
  ONCE = 0
  EVERY_WEEK = 1
  EVERY_2_WEEKS = 2
  EVERY_MONTH_DAY = 3
  EVERY_DAY_OF_WEEK_IN_MONTH = 4

  REPETITIONS  = [
                  [(I18n.t :no_repetition,  :scope => [:activerecord, :attributes, :worktime, :repetitions]), ONCE], 
                  [(I18n.t :every_week,     :scope => [:activerecord, :attributes, :worktime, :repetitions]), EVERY_WEEK], 
                  [(I18n.t :every_two_weeks, :scope => [:activerecord, :attributes, :worktime, :repetitions]), EVERY_2_WEEKS], 
                  [(I18n.t :every_month_day, :scope => [:activerecord, :attributes, :worktime, :repetitions]), EVERY_MONTH_DAY],
                  [(I18n.t :every_day_of_week_in_month, :scope => [:activerecord, :attributes, :worktime, :repetitions]), EVERY_DAY_OF_WEEK_IN_MONTH]
                 ]

  include Period::Format
  include Period::Util
  include Period::Check
  
  def validate
    
    if start_date > end_date
      add_period_error(:start_has_to_be_less_then_end, :start_date, :end_date)
    end

    if since > self.until
      add_period_error(:start_has_to_be_less_then_end)
    end
    
    if since == self.until 
      b = since.hour > self.until.hour 
      c = since.hour == self.until.hour and since.min > self.until.min
      if b or c
        add_period_error (:since_has_to_be_less_then_until)
      end
    end

    worktimes = Worktime.find(:all, :conditions => ["end_date >= ? and id != ?", self.start_date, (self.id == nil ? -1 : self.id)], :lock => true)
    # Check overlaping
    m_array = self.minutes_array
    for worktime in worktimes
      t_array =  worktime.minutes_array
      if minutes_array_overlap?(m_array, t_array)
        errors.add("worktime", errors.generate_message(:worktime,:exists_worktimes_that_overlaps_with_this_worktime) ) 
        break
      end
    end    
  end

  # Check if A1 and A2 has common parts
  # A1, A2 - arrays of integers [[a1, a2], [b1, b2], ...] where a1 <
  # a2, etc.
  def minutes_array_overlap?(a1, a2)
    for a in a1
      for b in a2
        if  (a[0] > b[0] and a[0] < b[1]) or
            (a[1] > b[0] and a[1] < b[1]) or
            (b[0] > a[0] and b[0] < a[1]) or
            (b[1] > a[0] and b[1] < a[1])
          return true
        end
      end
    end
    return false
  end
  
  # Returns minutes array for worktime
  # E.g.
  # For worktime: 2001-01-01, 2001-01-08, 08:30 - 10:30,
  # repetition=EVERY_WEEK returns
  # [[minutes from 1970 to since, minutes from 1970 to until],
  # [minutes from 1970 to since plus week, minutes from 1970 to until
  # plus week]] 
  def minutes_array
    day = self.start_date 
    minutes = []
    wday = self.start_date.wday
    week_in_month = self.start_date.mday / 7

    while day.to_time.to_i <= end_date.to_time.to_i

      t1 = (day + self.since.hour.hours) + self.since.min.minutes
      t2 = (day + self.until.hour.hours) + self.until.min.minutes

      minutes << [ t1.to_i / 60, t2.to_i / 60 ]
      if self.repetition == Worktime::ONCE then
        break
      elsif self.repetition == Worktime::EVERY_WEEK 
        day = day + 1.week
      elsif self.repetition == Worktime::EVERY_2_WEEKS
        day = day + 2.weeks
      elsif self.repetition == Worktime::EVERY_MONTH_DAY        
        if ( day + 1.month ).mday != day.mday
          day = day + 2.months
        else
          day = day + 1.month
        end
      elsif self.repetition == Worktime::EVERY_DAY_OF_WEEK_IN_MONTH
        # E.g. every second friday in month
        nday = day + 4.weeks
        
        if nday.mday / 7 != week_in_month
          nday = day + 5.weeks
        end
        
        if nday.mday / 7 != week_in_month
          nday = day + 3.weeks
        end

        if nday.mday / 7 != week_in_month
          raise "cannot set up week"
        end
        
        day = nday
      else
        raise "repetition not valid!"
      end

          
    end
    minutes
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

    absences = Absence.new.absences_at_day(doctor.id, day)
    reservations = VisitReservation.new.reservations_at_day(doctor.id, day)    
    visits = Visit.new.visits_at_day(doctor.id, day)

    # make array [[start, stop], ...]
    # from abcenses ...    
    exclusions = absences.collect { |a| logger.info(a.since.to_date < day.to_date ? 0 : Period::Util::day_minutes(a.since.to_time) ).to_s
      logger.info(a.until.to_date > day.to_date ? 24 * 60 : Period::Util::day_minutes(a.until.to_time) ).to_s
      logger.info a.since.to_date 
      logger.info a.until.to_date
      logger.info day
      [ a.since.to_date < day.to_date ? 0 : Period::Util::day_minutes(a.since.to_time) ,
        a.until.to_date > day.to_date ? 24 * 60 : Period::Util::day_minutes(a.until.to_time) 
      ] 
    }
    # ... and from reservations
    exclusions.concat reservations.collect { |a|[ a.since.to_date < day.to_date ? 0 : Period::Util::day_minutes(a.since.to_time),
                                                  a.until.to_date > day.to_date ? 24 * 60 : Period::Util::day_minutes(a.until.to_time) ] }
    # ... and from visits
    exclusions.concat visits.collect { |a| [ a.since.to_date < day.to_date ? 0 : Period::Util::day_minutes(a.since.to_time),
                                             a.until.to_date > day.to_date ? 24 * 60 : Period::Util::day_minutes(a.until.to_time) ] }
    available_periods( Period::Util::day_minutes(self.since.to_time), Period::Util::day_minutes(self.until), exclusions)          
  end

  # Choose all worktimes for parameters
  def self.available_worktimes(place_id, speciality_id, doctor_id, start_date)
    query = "select * from worktimes w"
    conditions = []
    parameters = []
    if place_id
      conditions << "w.place_id = ?"
      parameters << place_id
    end
    if speciality_id 
      conditions <<  " w.doctor_id in (select u.id from users u, doctor_specialities ds where ds.doctor_id = u.id and ds.speciality_id = ?) "
      parameters << speciality_id
    end
    if doctor_id
      conditions <<  " w.doctor_id = ? "
      parameters << doctor_id
    end

    if start_date 
      conditions <<  " ? between w.start_date and w.end_date "
      parameters << start_date
    end
    
    if conditions.count > 0
      query += " where " 
      for c in conditions
        query += c + " and "
      end
      query_with_params = [ query[0, query.length - 5] ]
      query_with_params.concat parameters
    else
      query_with_params = [query]
    end
    worktimes = Worktime.find_by_sql query_with_params    
  end

  # Choose all worktimes and return not_reserver
  def self.not_reserved_worktimes(day, doctor_id, place_id, speciality_id)
    hours = []
    for worktime in available_worktimes(place_id, speciality_id, doctor_id, day)
      hours.concat worktime.not_reserved_hours(day)
    end
    hours
  end

  # check absences and visits at this time for this doctor
  def self.available?(date_since, date_until, doctor_id, place_id, speciality_id)     
    logger.info " ================ SELF.SINCE ===== " + Period::Util::day_minutes(date_since).to_s + "    " +  Period::Util::day_minutes(date_until).to_s
    nr = Worktime.not_reserved_worktimes(date_since.to_date, doctor_id, place_id, speciality_id)
    # eg. nr == [[1040, 2030], [3000,4300]]
    ok = false
    nr.each {|r| logger.info "--------------> " + r[0].to_s + "  " +  r[1].to_s }   
    nr.each {|r| ok = true if r[0] <= Period::Util::day_minutes(date_since) and r[1] >= Period::Util::day_minutes(date_until) }
    ok
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
  

  def format_day_minutes_range(minutes_range)
    s = minutes_range [0]
    e = minutes_range [1]
    t1 = Time.gm(2000, 1, 1, s / 60, s % 60, 0)
    t2 = Time.gm(2000, 1, 1, e / 60, e % 60, 0)
    t1.strftime("%H:%M") + ".." + t2.strftime("%H:%M")
  end
end
