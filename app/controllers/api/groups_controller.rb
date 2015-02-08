class Api::GroupsController < ApplicationController
  
  acts_as_token_authentication_handler_for Instructor, except: [:student_index]
  acts_as_token_authentication_handler_for Student, only: [:student_index]

  def instructor_index
    groups = current_instructor.groups
    render json: { success:true, data:{:groups => groups},info:{} }, status: 200
  end

  def student_index
      groups = current_student.groups
      render json: { success:true, data:{:groups => groups}, info:{} }, status: 200
  end

  def instructor_show
      if (current_instructor.groups.exists?(:id => params[:id]))
        group = current_instructor.groups.find(params[:id])
        studens = group.students
        render json: {success:true, data:{:group => group, :students => students, info:{}} }, status: 200
      else
        render json: { success: false, data:{}, info:"group is not found"}, status: 404
      end
  end

  def add

    student = Student.find_by_id(params[:student][:id])
    group = Group.find_by_id(params[:group][:id])

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
