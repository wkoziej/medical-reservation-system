class PopulateData < ActiveRecord::Migration
  def self.up

    create_examination_kind("Hemanalysis")
    create_examination_kind("OB")
    create_examination_kind("Urine test")

    create_speciality ("Surgeon");
    create_speciality ("Paedatrican");
    create_speciality ("Dentist");
    create_speciality ("Dermatologist");   

    create_role("admin")
    create_role("patient")
    create_role("doctor")

    create_user_in_role("admin", "admin@localhost.com", "password", "admin", "Adam")  
    create_user_in_role("pacjent", "pacjent@localhost.com", "pacjent", "patient", "Pat")  
    create_user_in_role("doctor1", "doctor@localhost.com", "doctor1", "doctor", "Dr Doc")  
    create_user_in_role("doctor2", "doctor@localhost.com", "doctor2", "doctor", "Jakyll")  

    create_place("Lublin", "Batorego 11")
    create_place("Krakow", "Sieczki 33")
    create_place("Warszawa", "Szara 1/A")

    create_worktime("Lublin", '2009-01-01',  '2010-01-01', '18:30', '19:30', "Dr Doc", 1)
    create_worktime("Lublin", '2009-01-02',  '2010-01-02', '10:30', '14:30', "Dr Doc", 2)
    create_worktime("Warszawa", '2009-01-03',  '2010-01-03', '8:30', '10:30', "Dr Doc", 1)
    create_worktime("Krakow", '2009-01-01',  '2010-01-01', '18:30', '19:30', "Jakyll", 1)

    create_worktime("Lublin", '2009-01-04',  '2010-01-01', '18:30', '19:30', "Dr Doc", 1)
    create_worktime("Lublin", '2009-01-05',  '2010-01-02', '10:30', '14:30', "Dr Doc", 2)
    create_worktime("Warszawa", '2009-01-06',  '2010-01-03', '8:30', '10:30', "Dr Doc", 1)
    create_worktime("Krakow", '2009-01-07',  '2010-01-01', '18:30', '19:30', "Jakyll", 1)

  end

  def self.down
  end

private

  def self.create_place(name, address)
    place = Place.new
    place.name = name
    place.address = address
    place.save(false)
  end

  def self.create_speciality (name)
    speciality = Speciality.new
    speciality.name = name
    speciality.save
  end

  def self.create_examination_kind(name)
    kind = ExaminationKind.new
    kind.name = name
    kind.save
  end

  def self.create_role (role_name)
    role = Role.new
    role.name = role_name
    role.save(false)
  end

  def self.create_user_in_role (login, email, password, role_name, name)

    user = User.new
    user.login = login
    user.email = email
    user.password = password
    user.password_confirmation = password
    user.name = name
    user.save(false)   
    
    user = User.find_by_login(login)
    role = Role.find_by_name(role_name)
    user.activate!

    user.roles << role
    user.save(false)		

  end

  def self.create_worktime (place_name, start, stop, h_start, h_stop, doctor_name, repetition)
    worktime = Worktime.new
    worktime.place = Place.find_by_name(place_name)
    worktime.doctor = User.find_by_name(doctor_name)
    worktime.start_date = start
    worktime.end_date = stop
    worktime.since = h_start
    worktime.until = h_stop
    worktime.repetition = repetition
    worktime.save(false)
  end  

end
