class PlacesController < ApplicationController
  layout "application"
  require_role :admin

  def index
    @places = Place.find(:all)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @places }
    end
  end

  def show
    @place = Place.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @place }
    end
  end


  def new
    @place = Place.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @place }
    end
  end

  def edit
    @place = Place.find(params[:id])
  end

  def create
    @place = Place.new(params[:place])

    respond_to do |format|
      if @place.save
        flash[:notice] = t(:successfully_created, {:model => @place.class.human_name})
        format.html { redirect_to(places_url) }
        format.xml  { render :xml => @place, :status => :created, :location => @place }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @place.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @place = Place.find(params[:id])
    respond_to do |format|
      if @place.update_attributes(params[:place])
        flash[:notice] = t(:successfully_updated,  {:model => @place.class.human_name})
        format.html { redirect_to(places_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @place.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @place = Place.find(params[:id])
    if @place.destroy
      flash[:notice] = t(:successfully_deleted, {:model => @place.class.human_name})
    end
    respond_to do |format|
      format.html { redirect_to(places_url) }
      format.xml  { head :ok }
    end
  end
end
