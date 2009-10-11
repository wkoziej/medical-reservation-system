##require 'test_helper'
require File.dirname(__FILE__) + '/../test_helper'

class VisitTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "overlap" do
    a = Visit.new 
    a.since = '2000-01-01 08:00:00'
    a.until = a.since + 15.minutes
    a.patient_id = 1  
    a.doctor_id = 2
    
    a.save

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

    b.since = a.since + 15.minutes
    b.until = a.until + 15.minutes
    
    assert b.save

    b = Visit.new
    b.patient_id = 2 # 1
    b.doctor_id = 1 # 2

    b.since = a.since - 2.minutes
    b.until = a.until + 2.minutes

    assert b.save

  end
end
