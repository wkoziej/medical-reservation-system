class VisitReservationsController < ApplicationController
  layout "application"
  require_role "patient"


  def index

    if params[:doctor_id]
      @doctor = User.find_by_id (params[:doctor_id])
    elsif current_user.is_doctor?
      @doctor = current_user
    end
    
    if params[:patient_id]      
      @patient = User.find_by_id (params[:patient_id])
    elsif current_user.is_patient?
      @patient = current_user
    end
    
    conditions = {}
    if @doctor
      conditions[:doctor_id] = @doctor.id
    end
    if @patient
      conditions[:patient_id] = @patient.id
    end

    if @patient or @doctor 
      @reservations = VisitReservation.find(:all, :conditions => conditions)    
    else
      @reservations = []
    end

  end

  # Search form for visits
  def search_form
    @places = Place.find(:all)
    @specialities = Speciality.find(:all)
    @patient = User.find_by_id(params[:patient_id])
    respond_to do |format|
      format.html # search_form.html.erb
      format.xml  { render :xml => @worktime }
    end
  end

  # Available worktimes. We can give some conditions eg.:
  # place, doctor, speciality
  def available_worktimes
    place_id = extract_id(params, :place)
    @place = Place.find_by_id(place_id)
    speciality_id = extract_id(params, :speciality)
    @speciality = Speciality.find_by_id(speciality_id)
    doctor_id = extract_id(params, :doctor)
    @doctor = User.find_by_id(doctor_id)
    @patient = User.find_by_id(params[:patient_id])
    if params[:take_time_into_account]
      # HACK -> parsing parameters
      start = Worktime.new(params[:date_time]).start_date     
    else
      start = Date.today.to_date
    end
    @days = [ start.to_date ]
    for i in [1,2,3,4]     
      @days << start.to_date + i.day
    end
    respond_to do |format|
      format.html { render :template => "visit_reservations/available_worktimes" }
    end
  end

  def new
    @visit_reservation = VisitReservation.new
    @visit_reservation.patient_id = params[:patient_id] 
    if params[:doctor_id]
      @visit_reservation.doctor_id = params[:doctor_id]
    else
      # We have to show doctors
      @doctors = ApplicationHelper::users_in_role ('doctor')
    end
    if params[:date] 
      @visit_reservation.since = params[:date].to_date ###  + (params[:since_minute]).to_i.minutes
    else
      @visit_reservation.since = Date.new
    end

    @hours = []
    if params[:since_minute] and params[:until_minute]
      since_m = params[:since_minute].to_i
      until_m = params[:until_minute].to_i
    else
      since_m = 8*60
      until_m = 16*60
    end
    posibilities = (until_m - since_m) / 15
    i = since_m
    while i < until_m
      @hours << [format_hour_from_minutes(i), i]
      i = i + 15
    end
  end


  def create
    @visit_reservation = VisitReservation.new(params[:visit_reservation])
    @visit_reservation.since = @visit_reservation.since + params[:since_minutes].to_i.minutes
    @visit_reservation.until = @visit_reservation.since + 15.minutes
    @visit_reservation.status = VisitReservation::STATUS[:NEW]
    respond_to do |format|
      if @visit_reservation.save
        flash[:notice] = 'Visit_Reservation was successfully created.'
        format.html { redirect_to patient_visit_reservations_path(@visit_reservation.patient)  }
        format.xml  { render :xml => @visit_reservation, :status => :created, :location => @visit_reservation }
      else
        # !!!!!!!!!!!!!!!!!!!!!!!!111
        # !!!!!!!!!!!!!!!!!!!!!!!!
        flash[:notice] = 'Problems with saving visit_reservation.'
        format.html { redirect_to new_patient_visit_reservation_path(@patient, 
                                                                     :params => params[:visit_reservation].merge( {:date => @visit_reservation.since.to_date, :since_minute => params[:since_minutes], :until_minute => params[:until_minute], :aaaa=>111} ) ) }
        format.xml  { render :xml => @visit_reservation.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @visit_reservation = VisitReservation.find_by_id(params[:id])
    @visit_reservation.destroy
    respond_to do |format|
      format.html { redirect_to patient_visit_reservations_path(@visit_reservation.patient) }
      format.xml  { head :ok }
    end
  end

private
  def extract_id(params, object)
    return params[object][:id] if params and params[object] and params[object][:id] and params[object][:id].length > 0
  end

  def format_hour_from_minutes(i)
    t = Time.gm (2000, 1, 1, i / 60, i % 60, 0)
    t.strftime("%H:%M")
    #(i / 60).to_s + ":" + (i % 60).to_s
  end

end
