class Api::StudentsRegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  respond_to :json

  def create
    student = Student.create(student_params)

    if student.save
      sign_in 
      render status: 200,
              json: { success: true,
                      info: "Registered",
                      data: { :student => student,
                                 :auth_token => current_student.authentication_token } }
    else
      render status: :unprocessable_entity,
             json: { success: false,
                        info: student.errors,
                        data: {} }
    end
  end

  private

  def student_params
    params.require(:student).permit(:name,:email,:password,:password_confirmation)
  end
end
