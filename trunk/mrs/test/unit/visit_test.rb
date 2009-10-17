##require 'test_helper'
require File.dirname(__FILE__) + '/../test_helper'

class VisitTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "overlap" do
    ## Has to be worktime
    w = Worktime.new 
    w.start_date = '2000-01-01'
    w.end_date = '2000-01-01'
    w.since = '2000-01-01 00:00:00'
    w.until = '2000-01-01 23:00:00' 
    w.repetition = 1
    w.doctor_id = 2
    w.place_id = 2
    assert w.save 

    a = Visit.new 
    a.since = '2000-01-01 08:00:00'
    a.until = a.since + 15.minutes
    a.patient_id = 1  
    a.doctor_id = 2
    
    assert a.save

    b = Visit.new
    b.patient_id = 1  
    b.doctor_id = 2

    b.since = a.since - 2.minutes
    b.until = a.until + 2.minutes

    assert (not b.save)

    b.since = a.since + 2.minutes
    b.until = a.until + 2.minutes
    
    assert (not b.save)

    b.since = a.since + 2.minutes
    b.until = a.until - 2.minutes
    
    assert (not b.save)


    b.since = a.since - 2.minutes
    b.until = a.until - 2.minutes
    
    assert (not b.save)

    b.since = a.until
    b.until = a.until + 15.minutes
    

    assert b.save

    ## Has to be worktime
    w = Worktime.new 
    w.start_date = '2000-01-01'
    w.end_date = '2000-01-01'
    w.since = '2000-01-01 00:00:00'
    w.until = '2000-01-01 23:00:00' 
    w.repetition = 1
    w.doctor_id = 1 ## 2
    w.place_id = 2
    assert w.save 

    b = Visit.new
    b.patient_id = 2 # 1
    b.doctor_id = 1 # 2

    b.since = a.since - 2.minutes
    b.until = a.until + 2.minutes

    assert b.save

  end
end
