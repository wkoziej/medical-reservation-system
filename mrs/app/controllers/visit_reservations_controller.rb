class VisitReservationsController < ApplicationController
  layout "application"

  def index
  end

  def new
    @visit_reservation = VisitReservation 
    @places = Place.find(:all)
    @doctors = User.find(:all)
    @specialities = Speciality.find(:all)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @visit_reservatione}
    end
  end

  def search
    place = Place.find(params[:place][:id])
    doctor = User.find_doctors(params[:doctor][:id])
    speciality = Speciality.find(params[:speciality][:id])
    # Look for visit which can we reserve
    #### ... TODO
  end


  def edit
  end

end
