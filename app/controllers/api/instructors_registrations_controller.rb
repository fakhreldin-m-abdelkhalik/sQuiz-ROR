class Api::instructorsRegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  respond_to :json

  def create
    instructor = instructor.create(instructor_params)

    if instructor.save
      sign_in  instructor
      render status: 200,
              json: { success: true,
                      info: "Registered",
                      data: { :instructor => instructor,
                                 :auth_token => current_instructor.authentication_token } }
    else
      render status: :unprocessable_entity,
             json: { success: false,
                        info: instructor.errors,
                        data: {} }
    end
  end

  private

  def instructor_params
    params.require(:instructor).permit(:name,:email,:password,:password_confirmation)
  end
end
