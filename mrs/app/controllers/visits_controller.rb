class VisitsController < ApplicationController

  def index
    @visits = Visit.find(:all)
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
    elsif @visit.patient_id == nil and params[:patient_id] != nil
      @visit.patient_id = params[:patient_id]
    else
      # Have to choose patient !!!
      error_handling("You have to choose patient or visit reservation")
    end
    respond_to do |format|
      if @visit.save
        flash[:notice] = 'Visit was successfully created.'
        format.html { redirect_to(@visit) }
        format.xml  { render :xml => @visit, :status => :created, :location => @visit }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @visit.errors, :status => :unprocessable_entity }
      end
    end
  end


end
