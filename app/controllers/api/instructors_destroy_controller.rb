class Api::InstructorsDestroyController < ApplicationController

	acts_as_token_authentication_handler_for Instructor
	
	def destroy

	    temp = current_instructor
	    sign_out(current_instructor)
	    temp.update_column(:authentication_token, nil)
	    render status: 200,
	           json: { success: true,
	                      info: "Logged out",
	                      data: {} }
	end
end