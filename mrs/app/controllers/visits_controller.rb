class VisitsController < ApplicationController

  def index
    logger.info " ------ >>> " + params[:patient_id].to_s
    conditions = {}
    if params[:doctor_id]
      @doctor = User.find_by_id(params[:doctor_id])
      conditions = {:doctor_id => @doctor.id}
    elsif current_user.has_role?('doctor')
      @doctor = current_user
      conditions = {:doctor_id => @doctor.id}
    elsif params[:patient_id]      
      @patient = User.find_by_id(params[:patient_id])
      conditions = {:patient_id => @patient.id}
    elsif current_user.has_role?('patient')
      @patient = current_user
      conditions = {:patient_id => @patient.id}
    end
    
    @visits = Visit.find(:all, :conditions => conditions, :order => :since)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @visits }
    end

  end

  def new
    find_doctor
    @visit = Visit.new
    @visit.doctor = @doctor    
    @visit_reservations = VisitReservation.find_all_by_doctor_id_and_status(@doctor.id, "OPEN")
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @visit }
    end  
      
  end


  def create
    @visit = Visit.new(params[:visit])    
    if @visit and @visit.visit_reservation
      @visit.patient_id = @visit.visit_reservation.patient_id
      @visit.visit_reservation.use!
    end
    @visit.until =  @visit.since + params[:visit_minutes].to_i.minutes
    respond_to do |format|
      if @visit.save
        flash[:notice] = 'Visit was successfully created.'
        format.html { redirect_to(visits_path) }
        format.xml  { render :xml => @visit, :status => :created, :location => @visit }
      else
        find_doctor
        @visit_reservations = VisitReservation.find_all_by_doctor_id_and_status(@doctor.id, "OPEN")
        format.html { render :action => "new" }
        format.xml  { render :xml => @visit.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    find_doctor
    @visit = Visit.find_by_id(params[:id])
    @visit_reservations = VisitReservation.find_all_by_doctor_id_and_status(@doctor.id, :OPEN)
  end

  def update
    @visit = Visit.find(params[:id])
    @visit.until =  @visit.since + params[:visit_minutes].to_i.minutes
    respond_to do |format|
      if @visit.update_attributes(params[:visit])
        flash[:notice] = 'Visit was successfully updated.'
        format.html { redirect_to(visits_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @visit.errors, :status => :unprocessable_entity }
      end
    end
  end


  def destroy
    @visit = Visit.find(params[:id])
    if @visit.visit_reservation
      @visit.visit_reservation.reset!
    end
    if @visit.destroy
      flash[:notice] = 'Visit was successfully deleted.'
    end
    respond_to do |format|
      format.html { redirect_to(visits_url) }
      format.xml  { head :ok }
    end
  end

  def show
    @visit = Visit.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @visit }
    end
  end

  def find_doctor
    if params[:doctor_id]
      @doctor = User.find_by_id(params[:doctor_id])
    elsif current_user.has_role?('doctor')
      @doctor = current_user
    else
      ## TODO Error handling
      error_handling("Cannot register new visit if there is no doctor")
    end   
  end

end
