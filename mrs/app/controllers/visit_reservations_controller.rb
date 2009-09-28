class VisitReservationsController < ApplicationController
  layout "application"
  require_role "patient"

  def index
    @patient = current_user if current_user.has_role? 'patient'
  end

  def new
    @places = Place.find(:all)
    @specialities = Speciality.find(:all)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @visit_reservation}
    end
  end

  #
  #
  def search
  end

  def edit
  end

end
