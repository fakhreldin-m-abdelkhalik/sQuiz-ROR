class Api::SignoutController < ApplicationController

	acts_as_token_authentication_handler_for Instructor, only: [:instructor_destroy]
	acts_as_token_authentication_handler_for Student, only: [:student_destroy]

	
	def instructor_destroy

	    temp = current_instructor
	    sign_out(current_instructor)
	    temp.update_column(:authentication_token, nil)
	    render status: 200,
	           json: { success: true,
	                      info: "Logged out",
	                      data: {} }
	end

	def student_destroy

	    temp = current_student
	    sign_out(current_student)
	    temp.update_column(:authentication_token, nil)
	    render status: 200,
	           json: { success: true,
	                      info: "Logged out",
	                      data: {} }
	end
end