class VisitReservationsController < ApplicationController
  layout "application"
  require_role "patient"

  def index
    @patient = current_user if current_user.has_role? ('patient')
  end

  def new
    @visit_reservation = VisitReservation 
    @places = Place.find(:all)
    @doctors = User.find_users_in_role('doctor')
    @specialities = Speciality.find(:all)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @visit_reservation}
    end
  end

  def edit
  end

end
