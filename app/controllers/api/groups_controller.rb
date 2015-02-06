class Api::GroupsController < ApplicationController
  
  acts_as_token_authentication_handler_for Instructor

  def add

    student = Student.find(params[:student][:id])
    group = Group.find(params[:group][:id])

    if(!student)
      render status: :unprocessable_entity,
             json: { success: false,
                        info: "Student does not exit",
                        data: {} }

    elsif(!group)
      render status: :unprocessable_entity,
             json: { success: false,
                        info: "Group does not exit",
                        data: {} }  

    elsif (group.students.include?(student))
      render status: :unprocessable_entity,
             json: { success: false,
                        info: "Student already exists in this group",
                        data: {} }  
        
    elsif(group.instructor == current_instructor)

      group.students << student
      render status: 200,
              json: { success: true,
                      info: "Added",
                      data: { instructor: current_instructor,
                              student: student , group: group} }
    else
      render status: :unprocessable_entity,
             json: { success: false,
                        info: "Instructor is not authorized to add students to this group",
                        data: {} }

    end                    

  end

  def remove

    student = Student.find(params[:student][:id])
    group = Group.find(params[:group][:id])

    if(group.instructor == current_instructor)

      group.students.delete(student)
      render status: 200,
              json: { success: true,
                      info: "Removed",
                      data: { instructor: current_instructor,
                              student: student , group: group} }
    else
      render status: :unprocessable_entity,
             json: { success: false,
                        info: "Instructor is not authorized to remove students to this group",
                        data: {} }

    end                    

  end

end
