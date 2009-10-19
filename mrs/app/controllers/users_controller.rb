class UsersController < ApplicationController
  layout "application"
  # Protect these actions behind an admin login
  before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge, :show]  
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge]

  
  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    @user.register! if @user && @user.valid?
    success = @user && @user.valid?
    if success && @user.errors.empty?
      redirect_back_or_default('/')
      flash[:notice] = t(:thanks_for_signing_up)     
    else
      flash[:error]  = t(:we_couldnt_set_up_that_account)
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = t(:signup_complete)
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = t(:activation_code_was_missing)
      redirect_back_or_default('/')
    else 
      flash[:error]  = t(:couldnt_find_a_user_with_that_activation_code)
      redirect_back_or_default('/')
    end
  end

  def suspend
    @user.suspend! 
    redirect_to users_path
  end

  def unsuspend
    @user.unsuspend! 
    redirect_to users_path
  end

  def destroy
    @user.delete!
    redirect_to users_path
  end

  def purge
    @user.destroy
    redirect_to users_path
  end
  
  def index
    @users = User.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.xml  { render :xml => @user }
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = t(:successfully_updated, {:model => @user.class.human_name})
        format.html { redirect_to(users_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # There's no page here to update or destroy a user.  If you add those, be
  # smart -- make sure you check that the visitor is authorized to do so, that they
  # supply their old password along with a new one to update it, etc.

protected
  def find_user
    @user = User.find(params[:id])
  end

  def admin_required
    current_user.has_role?('admin')
  end
end
