# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
SquashLeague::Application.initialize!

#necessary for sending smtp emails through gmail
ActionMailer::Base.delivery_method = :smtp
