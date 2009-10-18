# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :set_locale
  
  layout "application"

   
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # You can move this into a different controller, if you wish.  This module gives you the require_role helpers, and others.
  include RoleRequirementSystem

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '852611a46732cec3f36d3e759e7ddd48'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password

  def set_locale
    logger.info "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
    I18n.locale = extract_locale_from_accept_language_header
    logger.info "* Locale set to '#{I18n.locale}'"
  end
  
  private
  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end
  
  private
  def is_admin
    if current_user.type != 'Admin' then
      flash[:notice] = "You are not allowed to access this page...";
      redirect_to(login_url)
    end
  end
end
