class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  #along with the remember_token, allows users to stay logged in until they choose to log out
  include SessionsHelper
  include AdminHelper
  include LeagueHelper
end
