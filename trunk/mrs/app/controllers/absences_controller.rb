class AbsencesController < ApplicationController
  
  def index
    @doctor = User.find_by_id(params[:user_id])
    @doctor = current_user if current_user.has_role? 'doctor' and not @doctor 
    @absences = Absence.find_all_by_doctor_id(@doctor.id) 
  end

  def new
    @absence = Absence.new
    @absence.doctor_id = params[:user_id]
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @absence }
    end
  end

  def create
    @absence = Absence.new(params[:absence])
    respond_to do |format|
      if @absence.save
        flash[:notice] = t(:successfully_created, {:model => @absence.class.human_name} )
        format.html { redirect_to user_absences_path(@absence.doctor_id) }
        format.xml  { render :xml => @absence, :status => :created, :location => @absence }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @absence.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @absence = Absence.find(params[:id])
  end


  def update
    @absence = Absence.find(params[:id])
    respond_to do |format|
      if @absence.update_attributes(params[:absence])
        flash[:notice] = t(:successfully_updated, {:model => @absence.class.human_name} )
        format.html { redirect_to(user_absences_url(@absence.doctor)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @absence.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @absence = Absence.find(params[:id])
    @absence.destroy

    respond_to do |format|
      format.html { redirect_to user_absences_path(@absence.doctor_id) }
      format.xml  { head :ok }
    end
  end


end
