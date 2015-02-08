class Api::StudentsDestroyController < ApplicationController

	acts_as_token_authentication_handler_for Student
	
	def destroy

	    temp = current_student
	    sign_out(current_student)
	    temp.update_column(:authentication_token, nil)
	    render status: 200,
	           json: { success: true,
	                      info: "Logged out",
	                      data: {} }
	end
end