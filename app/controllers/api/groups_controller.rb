class Api::GroupsController < ApplicationController
  
  acts_as_token_authentication_handler_for Instructor, except: [:student_index]
  acts_as_token_authentication_handler_for Student, only: [:student_index]

  def instructor_index
    groups = current_instructor.groups
    render json: groups.as_json(:only => [:name, :id]), status: 200
  end

  def student_index
    groups = current_student.groups
    render json: { success:true, data:{:groups => groups}, info:{} }, status: 200
  end 

  def instructor_show
      if (current_instructor.groups.exists?(:id => params[:id]))
        group = current_instructor.groups.find(params[:id])
        students = group.students
        render json: students.as_json(:only => [:name, :id, :email]), status: 200
      else
        render json: { error:"group is not found"}, status: 404
      end
  end

  def add

    student = Student.find_by_email(params[:email])
    group = Group.find_by_id(params[:group_id])

    if(!student)
      render status: :unprocessable_entity,
             json: { error: "Student does not exit" }

    elsif(!group)
      render status: :unprocessable_entity,
             json: { error: "Group does not exit"}  

    elsif (group.students.include?(student))
      render status: :unprocessable_entity,
             json: { error: "Student already exists in this group"}  
        
    elsif(group.instructor == current_instructor)

      group.students << student
      render status: 200,
              json: student.as_json(:only => [:name, :id, :email])
    else
      render status: :unprocessable_entity,
             json: { error: "Instructor is not authorized to add students to this group" }

    end                    

  end

  def remove
    ins_groups = current_instructor.groups
    if( ins_groups.exists?(:id => params[:group_id]) )
      group = ins_groups.find(params[:group_id])
      students = group.students
      ids = []
      i = 0

      while ( params["_json"][i] != nil ) do
        ids << (params["_json"][i]["id"]).to_i 
        i = i + 1
      end

      ids.each do |id|
        if (students.exists?(:id => id))
          students.delete(Student.find(id))
        end
      end

      render json: {info:"deleted"}, status: 200  
    else
      render json: {error:"Group is not found"}, status: 200
    end                   
  end




  def create
    tempgroup = Group.where(name:params[:group][:name]).where(instructor: current_instructor).first

    if(tempgroup == nil) 
      my_create_group_function
    else  
      render status: 400, json: { error: "You Can't make another group with the same name " }
    end 
  end


  def destroy
    ids = []
    i = 0

    while ( params["_json"][i] != nil ) do
      ids << (params["_json"][i]["id"]).to_i 
      i = i + 1
    end

    ids.each do |id|
      if (current_instructor.groups.exists?(:id => id))
        Group.find(id).destroy
      end
    end

    render json: {info:"deleted"}, status: 200     
  end

  private

  def group_params
      params.require(:group).permit(:name)
  end 

  def my_create_group_function
    group = Group.new( group_params )
    group.instructor = current_instructor
    if group.save
      render status: 200,
      json: group.as_json(:only => [:id, :name])
    else
      render status: :unprocessable_entity,
      json: { error: group.errors }
    end
  end  
end
