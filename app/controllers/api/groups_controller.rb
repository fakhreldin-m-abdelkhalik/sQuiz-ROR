class Api::GroupsController < Devise::RegistrationsController
  
  respond_to :json

  def add

    student = Student.find(student_params)
    group = Group.find(group_params)

    if(group.instructor == current_isntructor)

      group.students << student
      render status: 200,
              json: { success: true,
                      info: "Added",
                      data: { instructor: instructor,
                              student: student , group: group} }
    else
      render status: :unprocessable_entity,
             json: { success: false,
                        info: "Instructor is noy authorized to add students from this group",
                        data: {} }

    end                    

  end

  def remove

    student = Student.find(student_params)
    group = Group.find(group_params)

    if(group.instructor == current_isntructor)

      group.students.delete(student)
      render status: 200,
              json: { success: true,
                      info: "Removed",
                      data: { instructor: current_isntructor,
                              student: student , group: group} }
    else
      render status: :unprocessable_entity,
             json: { success: false,
                        info: "Instructor is noy authorized to remove students from this group",
                        data: {} }

    end                    

  end

  private

  def student_params
    params.require(:student).permit(:id)
  end

  def group_params
    params.require(:group).permit(:id)
  end
 
end
