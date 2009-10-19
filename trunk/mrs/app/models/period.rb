module Period
  
  module Util
    def rows_at_day(day, condition, parameters)      
      self.class.find(:all, :conditions => [ "( :day between since and until or " + 
                                             " (since between :day and :next_day) or " + 
                                             " (until between :day and :next_day) ) " +
                                             (condition ? " and " + condition : "").to_s,
                                             { :day => day, :next_day => (day + 1.days) } .merge(parameters)
                                           ])      
    end

    def self.day_minutes(date)
      date.to_time.hour * 60 + date.to_time.min
    end
    
  end

  module Check
    # overlaping posibilities
    #
    #    since                until
    # a   |--------------------|
    # b        |-------|
    #          d1     d2
    #
    # a   |--------------------|
    # b                   |-------|
    #
    # a        |--------------------|
    # b   |-------|
    #
    # a        |----------|
    # b   |--------------------|
    #
    # do not overlap
    # a                           |----------|
    # b   |--------------------|
    def period_overlap?(condition, parameters)      
      r = self.class.find(:first, :conditions => [ "id != :id and " + 
                                                   "( (:d1   between since and until and :d1 != until) or " +
                                                   "  (:d2   between since and until and :d2 != since) or " + 
                                                   "  (since between :d1   and :d2   and since != :d2) or " + 
                                                   "  (until between :d1   and :d2   and until != :d1)   ) " +
                                                   (condition ? " and " + condition : "").to_s,
                                                   { :id => self.id ? self.id : -1, :d1 => self.since, :d2 => self.until }.merge(parameters)
                                              ])
    end

    def period_valid?      
      self.since != nil and self.until != nil and self.since < self.until
    end

    def add_period_error (error_code, start = :since, stop = :until)
      errors.add(start, errors.generate_message(start, error_code,
                                                 :field =>  self.class.human_attribute_name(stop.to_s)))
      errors.add(stop, errors.generate_message(stop, error_code,
                                               :field =>  self.class.human_attribute_name(start.to_s)))
    end
  end
  
  module Format
    
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

    def formated_since
      t = since.hour.to_s + ":" + since.min.to_s
    end

    def formated_until
      t = self.until.hour.to_s + ":" + self.until.min.to_s
    end

  end
  
end
