class Api::StudentsCreateController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }
  
  respond_to :json

  def create
    warden.authenticate!(scope: resource_name, recall: "#{controller_path}#failure")
    render status: 200,
           json: { success: true,
                      info: "Logged in",
                      data: { auth_token: current_student.authentication_token } }
  end

  def failure
    render :status => 401,
           :json => { :success => false,
                      :info => "Login Failed",
                      :data => {} }
  end
end