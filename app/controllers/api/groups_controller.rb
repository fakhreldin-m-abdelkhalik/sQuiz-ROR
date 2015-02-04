class Api::GroupsController < Devise::RegistrationsController
  
  respond_to :json

  def add

    instructor = Instructor.find_by_authentication_token(instructor_params)
    student = Student.find(student_params)
    group = Group.find(group_params)

    if(group_owner_is_correct(instructor,group))

      group.students << student
      render status: 200,
              json: { success: true,
                      info: "Added",
                      data: { instructor: instructor,
                              student: student , group: group} }
    else
      render status: :unprocessable_entity,
             json: { success: false,
                        info: {instructor: instructor.errors , student: student.errors , group: group.errors},
                        data: {} }

    end                    

  end

  def remove

    instructor = Instructor.find_by_authentication_token(instructor_params)
    student = Student.find(student_params)
    group = Group.find(group_params)

    if(group_owner_is_correct(instructor,group))

      group.students.delete(student)
      render status: 200,
              json: { success: true,
                      info: "Removed",
                      data: { instructor: instructor,
                              student: student , group: group} }
    else
      render status: :unprocessable_entity,
             json: { success: false,
                        info: {instructor: instructor.errors , student: student.errors , group: group.errors},
                        data: {} }

    end                    

  end

  private

  def instructor_params
    params.require(:instructor).permit(:authentication_token)
  end

  def student_params
    params.require(:student).permit(:id)
  end

  def group_params
    params.require(:group).permit(:id)
  end

  def group_owner_is_correct( applicant, group)

    if(group.instructor == applicant)
      true
    else
      false
    end
  end
 
end
