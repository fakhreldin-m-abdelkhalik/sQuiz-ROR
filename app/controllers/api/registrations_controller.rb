class Api::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  respond_to :json

  def instructor_create
    instructor = Instructor.create(instructor_params)

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

  def student_create
    student = Student.create(student_params)

    if student.save
      sign_in  student
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

  def instructor_params
    params.require(:instructor).permit(:name,:email,:password,:password_confirmation)
  end

  def student_params
    params.require(:student).permit(:name,:email,:password,:password_confirmation)
  end
end