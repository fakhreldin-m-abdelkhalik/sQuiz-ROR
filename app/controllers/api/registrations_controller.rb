class Api::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  respond_to :json

  def instructor_create

    if email_is_not_taken(params[:instructor][:email])
      instructor = Instructor.create(instructor_params)

      if instructor.save
        sign_in  instructor
        render status: 200,
                json: { success: true,
                        info: "Registered",
                        instructor: instructor,
                        :auth_token => current_instructor.authentication_token }
      else
        render status: :unprocessable_entity,
               json: { error: instructor.errors }
      end
    else
      render status: :unprocessable_entity,
               json: { error: "Email is already taken" }
    end

  end

  def student_create

    if email_is_not_taken(params[:student][:email])
      student = Student.create(student_params)

      if student.save
        sign_in  student
        render status: 200,
                json: { success: true,
                        info: "Registered",
                        student: student,
                        :auth_token => current_student.authentication_token }
      else
        render status: :unprocessable_entity,
               json: { error: student.errors }
      end
    else
      render status: :unprocessable_entity,
               json: { error: "Email is already taken" }
    end

  end

  private

  def instructor_params
    params.require(:instructor).permit(:name,:email,:password,:password_confirmation)
  end

  def student_params
    params.require(:student).permit(:name,:email,:password,:password_confirmation)
  end

  def email_is_not_taken(email)
    if (Instructor.find_for_database_authentication(email: email) || Student.find_for_database_authentication(email: email))
      false
    else
      true
    end
  end
end