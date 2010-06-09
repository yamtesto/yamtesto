# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  def logged_in?
    begin
      uid = session[:user_id].to_i
      key = session[:session_key]
      return false unless uid && key
      # logged in & match key?
      user = User.find(uid)
      if user.session_key && (user.session_key == key)
        @logged_in_user = user
      end
    rescue
      false
    end
  end

  def authenticate(user, pwd)
    if user.can_has_access?(pwd)
      session[:user_id] = user.id
      session[:session_key] = user.session_key
    end rescue nil
  end
end
