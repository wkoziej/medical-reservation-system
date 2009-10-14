# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  DELETE_IMG = "32x32/delete.png"
  EDIT_IMG = "32x32/edit.png"
  ADD_IMG =  "32x32/add.png"
  SEARCH_IMG =  "32x32/zoom.png"
  DETAILS_IMG =  "32x32/full_page.png"

  TIME_FORMAT = "%H:%M"
  DATETIME_FORMAT = "%Y-%m-%d " + TIME_FORMAT

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

  def available_specialities(doctor_id)
    Speciality.find_by_sql ["select distinct s.* from specialities s where s.id not in (select ds.speciality_id from doctor_specialities ds where ds.doctor_id = ? )", doctor_id]    
  end

  def self.users_in_role(role_name)
    User.find_by_sql ["select distinct u.* from users u, roles r, roles_users ru where u.id = ru.user_id and r.id = ru.role_id and r.name = ?", role_name] 
  end


  def self.users_in_role_with_id(role_id)
    User.find_by_sql ["select distinct u.* from users u, roles_users ru where u.id = ru.user_id and ru.role_id  = ?", role_id] 
  end

  def users_in_role_in_place(role_name, place_id)
    User.find_by_sql ["select distinct u.* from users u, roles r, roles_users ru, doctor_specialities ds, worktimes w where u.id = ru.user_id and r.id = ru.role_id and ds.doctor_id = u.id and w.doctor_id = ds.doctor_id and r.name = ? and w.place_id = ? ", role_name, place_id]
  end

  def self.available_worktimes(place_id, speciality_id, doctor_id, start_date)
    Worktime.available_worktimes(place_id, speciality_id, doctor_id, start_date)
  end
 
end
