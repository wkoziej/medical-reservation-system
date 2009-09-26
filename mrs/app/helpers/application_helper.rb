# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def doctors_with_speciality (speciality_id)
    User.find_by_sql ["select distinct u.* from users u, doctor_specialities ds where u.id = ds.doctor_id and ds.speciality_id = ?", speciality_id] 
  end

  def doctors_from_place_with_speciality (place_id, speciality_id)   
    User.find_by_sql ["select distinct u.* from users u, doctor_specialities ds, worktimes w where u.id = ds.doctor_id and w.doctor_id = u.id and w.place_id = ? and ds.speciality_id = ?", place_id, speciality_id] 
  end

  def specialities_in_place (place_id)
    Speciality.find_by_sql ["select distinct s.* from specialities s, doctor_specialities ds, worktimes w where s.id = ds.speciality_id and w.doctor_id = ds.doctor_id and w.place_id = ? ", place_id]     
  end

  def doctor_specialities (doctor_id)
    Speciality.find_by_sql ["select distinct s.* from specialities s, doctor_specialities ds where s.id = ds.speciality_id and ds.doctor_id = ? ", doctor_id]    
  end

  def available_specialities (doctor_id)
    Speciality.find_by_sql ["select distinct s.* from specialities s where s.id not in (select ds.speciality_id from doctor_specialities ds where ds.doctor_id = ? )", doctor_id]    
  end
end
