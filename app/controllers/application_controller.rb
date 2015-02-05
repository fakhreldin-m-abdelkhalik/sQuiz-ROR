class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
    acts_as_token_authentication_handler_for Student
    acts_as_token_authentication_handler_for Instructor
end
