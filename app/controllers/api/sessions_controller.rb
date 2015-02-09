class Api::SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }
 
  respond_to :json

  def instructor_create
    Instructor.authenticate!(email,password, recall: "#{controller_path}#student_create")
    render status: 200,
           json: { success: true,
                      info: "Logged in",
                      data: { auth_token: current_instructor.authentication_token } }
  end


  def failure
    render :status => 401,
           :json => { :success => false,
                      :info => "Login Failed",
                      :data => {} }
  end
end