class WorktimesController < ApplicationController

  def index
    user_id = params[:user_id]
    @user = User.find_by_id(user_id)
    @worktimes = @user.worktimes
    if @worktimes == nil       
      respond_to do |format|
        format.html { redirect_to new_worktime_path(@user) }
        format.xml  { render :xml => @worktimes }
      end
    else 
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @worktimes }
      end
    end
  end

  def new 
    @worktime = Worktime.new    
    @places = Place.find(:all)
    @user = User.find_by_id(params[:user_id])
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @worktime }
    end
  end


  # Available worktimes. We can give some conditions eg.:
  # place, doctor, speciality
  def available
    place_id = extract_id(params[:place][:id])
    speciality_id = extract_id(params[:speciality][:id])
    doctor_id = extract_id(params[:doctor][:id])
    if params[:take_time_into_account]
#      d = params[:date]
      start = Date.new(params[:datetime])
#      start = d[:year] + "-" + d[:month] + "-" + d[:day] + " " +d[:hour]+":"+d[:minute]
      logger.info "   ------------>       " +  start
    else
      start = Date.today
    end

    # query about worktimes minus absences and reservations
    @worktimes = ApplicationHelper::available_worktimes(place_id, speciality_id, doctor_id, start.to_date)    
    @days = [ start.to_date ]
    for i in [1,2,3,4,5,6]     
      @days << start.to_date + i.day
    end
    respond_to do |format|
      format.html { render :template => "worktimes/available" }
    end
  end


  def destroy
    @worktime = Worktime.find(params[:id])
    if @worktime.destroy
      respond_to do |format|
        flash[:notice] = 'Worktime was successfully deleted.'
        format.html { redirect_to user_worktimes_path(@worktime.doctor) }
        format.xml  { render :xml => @worktime, :status => :created, :location => @worktime }    
      end
    end
  end

  def create
    @worktime = Worktime.new(params[:worktime])
    respond_to do |format|
      if @worktime.save
        flash[:notice] = 'Worktime was successfully created.'
        format.html { redirect_to user_worktimes_path(@worktime.doctor)  }
        format.xml  { render :xml => @worktime, :status => :created, :location => @worktime }
      else
        flash[:notice] = 'Problems with saving worktime.'
        @places = Place.find(:all)
        @user = @worktime.doctor
        format.html { render :template => "worktimes/new" }
        format.xml  { render :xml => @worktime.errors, :status => :unprocessable_entity }
      end
    end

  end
private
  def extract_id(object)
    object and object.to_s.length > 0 ? object : nil
  end

end
