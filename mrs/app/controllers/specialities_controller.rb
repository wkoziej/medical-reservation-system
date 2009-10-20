class SpecialitiesController < ApplicationController
  layout "application"
  require_role :admin

  # GET /specialities
  # GET /specialities.xml
  def index
    @specialities = Speciality.paginate :page => params[:page], :order => 'created_at DESC'
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @specialities }
    end
  end

  # GET /specialities/1
  # GET /specialities/1.xml
  def show
    @speciality = Speciality.find(params[:id])
    respond_to do |format|
      format.xml  { render :xml => @speciality }
    end
  end

  # GET /specialities/new
  # GET /specialities/new.xml
  def new
    @speciality = Speciality.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @speciality }
    end
  end

  # GET /specialities/1/edit
  def edit
    @speciality = Speciality.find(params[:id])
  end

  # POST /specialities
  # POST /specialities.xml
  def create
    @speciality = Speciality.new(params[:speciality])

    respond_to do |format|
      if @speciality.save
        flash[:notice] = t(:successfully_created, {:model => @speciality.class.human_name} )
        format.html { redirect_to(specialities_url) }
        format.xml  { render :xml => @speciality, :status => :created, :location => @speciality }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @speciality.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /specialities/1
  # PUT /specialities/1.xml
  def update
    @speciality = Speciality.find(params[:id])

    respond_to do |format|
      if @speciality.update_attributes(params[:speciality])
        flash[:notice] = t(:successfully_updated, {:model => @speciality.class.human_name} )
        format.html { redirect_to(specialities_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @speciality.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /specialities/1
  # DELETE /specialities/1.xml
  def destroy
    @speciality = Speciality.find(params[:id])
    if @speciality.destroy
      flash[:notice] = t(:successfully_deleted, {:model => @speciality.class.human_name} )
    end
    respond_to do |format|
      format.html { redirect_to(specialities_url) }
      format.xml  { head :ok }
    end
  end
end
