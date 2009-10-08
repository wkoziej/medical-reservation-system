class VisitsController < ApplicationController

  def index
    logger.info " ------ >>> " + params[:patient_id].to_s
    conditions = {}
    if params[:doctor_id]
      @doctor = User.find_by_id (params[:doctor_id])
      conditions = {:doctor_id => @doctor.id}
    elsif current_user.has_role?('doctor')
      @doctor = current_user
      conditions = {:doctor_id => @doctor.id}
    elsif params[:patient_id]      
      @patient = User.find_by_id (params[:patient_id])
      conditions = {:patient_id => @patient.id}
    elsif current_user.has_role?('patient')
      @patient = current_user
      conditions = {:patient_id => @patient.id}
    end
    
    @visits = Visit.find(:all, :conditions => conditions)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @visits }
    end

  end

  def new
    if params[:doctor_id]
      @doctor = User.find_by_id (params[:doctor_id])
    elsif current_user.has_role?('doctor')
      @doctor = current_user
    else
      ## TODO Error handling
      error_handling ("Cannot register new visit if there is no doctor")
    end
    
    @visit = Visit.new
    @visit.doctor = @doctor    

    @visit_reservations = VisitReservation.find_all_by_doctor_id_and_status (@doctor.id, VisitReservation::STATUS[:NEW])
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @visit }
    end  
      
  end


  def create
    @visit = Visit.new(params[:visit])
    if @visit and @visit.visit_reservation
      @visit.patient_id = @visit.visit_reservation.patient_id
      @visit.since = @visit.visit_reservation.since
    elsif @visit.patient_id == nil and params[:patient_id] != nil
      @visit.patient_id = params[:patient_id]
    else
      # Have to choose patient !!!
      error_handling("You have to choose patient or visit reservation")
    end

    @visit.since = Date.today if @visit and not @visit.since
    
    respond_to do |format|
      if @visit.save
        flash[:notice] = 'Visit was successfully created.'
        format.html { redirect_to(visits_path) }
        format.xml  { render :xml => @visit, :status => :created, :location => @visit }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @visit.errors, :status => :unprocessable_entity }
      end
    end
  end

def destroy
    @visit = Visit.find(params[:id])
    @visit.destroy

    respond_to do |format|
      format.html { redirect_to(visits_url) }
      format.xml  { head :ok }
    end
  end

#  def show
#    @visit = Visit.find(params[:id])
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @visit }
#    end
#  end


end
