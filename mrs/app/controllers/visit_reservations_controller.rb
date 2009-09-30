class VisitReservationsController < ApplicationController
  layout "application"
  require_role "patient"


  def index
    if current_user.has_role? 'patient'
      @patient = current_user 
    else
      @patient = params[:patient_id]
    end
    @reservations = VisitReservation.find_all_by_patient_id (@patient.id) 
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
    place_id = extract_id(params[:place][:id])
    @place = Place.find_by_id(place_id)
    speciality_id = extract_id(params[:speciality][:id])
    @speciality = Speciality.find_by_id(speciality_id)
    doctor_id = extract_id(params[:doctor][:id])
    @doctor = User.find_by_id(doctor_id)
    @patient = User.find_by_id(params[:patient_id])
    if params[:take_time_into_account]
      # HACK -> parsing parameters
      start = Worktime.new(params[:date_time]).start_date     
    else
      start = Date.today.to_date
    end

    # query about worktimes minus absences and reservations
    @worktimes = ApplicationHelper::available_worktimes(place_id, speciality_id, doctor_id, start)
    @days = [ start.to_date ]
    for i in [1,2,3,4,5,6]     
      @days << start.to_date + i.day
    end
    respond_to do |format|
      format.html { render :template => "visit_reservations/available_worktimes" }
    end
  end

  def new
    @visit_reservation = VisitReservation.new
    @visit_reservation.doctor_id = params[:doctor_id]
    @visit_reservation.patient_id = params[:patient_id]
    @visit_reservation.since = params[:date].to_date ###  + (params[:since_minute]).to_i.minutes
    @hours = []
    since_m = params[:since_minute].to_i
    until_m = params[:until_minute].to_i
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
#    @visit_reservation.until = @visit_reservation.since + 15.minutes
    respond_to do |format|
      if @visit_reservation.save
        flash[:notice] = 'Visit_Reservation was successfully created.'
        format.html { redirect_to patient_visit_reservations_path(@visit_reservation.doctor)  }
        format.xml  { render :xml => @visit_reservation, :status => :created, :location => @visit_reservation }
      else
        # !!!!!!!!!!!!!!!!!!!!!!!!111
        # !!!!!!!!!!!!!!!!!!!!!!!!
        flash[:notice] = 'Problems with saving visit_reservation.'
        format.html { redirect_to new_patient_visit_reservation_path(@patient, 
                                                                     :params => params[:visit_reservation].merge( {:date => @visit_reservation.since.to_date} ) ) }
        format.xml  { render :xml => @visit_reservation.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @visit_reservation = VisitReservation.find_by_id(params[:id])
    @visit_reservation.destroy
    respond_to do |format|
      format.html { redirect_to patient_visit_reservations_path(@visit_reservation.doctor) }
      format.xml  { head :ok }
    end
  end

private
  def extract_id(object)
    object and object.to_s.length > 0 ? object : nil
  end

  def format_hour_from_minutes(i)
    (i / 60).to_s + ":" + (i % 60).to_s
  end

end
