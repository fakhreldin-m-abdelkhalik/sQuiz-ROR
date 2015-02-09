class Api::SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }
 
  respond_to :json

  def instructor_create

    instructor =Instructor.find_for_database_authentication(:email => params[:email])
    if instructor && instructor.valid_password?(params[:password])
        sign_in(instructor)
        render status: 200,
           json: { success: true,
                      info: "Logged in",
                      data: { auth_token: current_instructor.authentication_token } }
    else

      student = Student.find_for_database_authentication(:email => params[:email])
      if student && student.valid_password?(params[:password])
        sign_in(student)
        render status: 200,
           json: { success: true,
                      info: "Logged in",
                      data: { auth_token: current_student.authentication_token } }
      else
        render :status => 401,
           :json => { :success => false,
                      :info => "Login Failed",
                      :data => {} }
      end

    end
    
  end

end