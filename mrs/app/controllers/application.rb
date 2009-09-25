# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  layout "application"

  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # You can move this into a different controller, if you wish.  This module gives you the require_role helpers, and others.
  include RoleRequirementSystem


  def will_paginate
    true
  end

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '852611a46732cec3f36d3e759e7ddd48'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password
  private
    def is_admin
       if current_user.type != 'Admin' then
	  flash[:notice] = "You are not allowed to access this page...";
	  redirect_to(login_url)
       end
    end
end
