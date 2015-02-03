module Api
	class QuizzesController < ApplicationController
		#skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
		#before_action :authenticate_instructor!, only: [:create,:destroy,:show,:index]
		respond_to :json

		#This method is used to get quiz by taking the quiz id from the client.
		def show
			quiz = current_instructor.quizzes.find(params[:id])
			render json: { data:{:quiz => quiz} }, status: 200
		end
		#This method creates new quiz by taking the quiz attributes from JSON object 
		#and it returns the JSON representation of the newly created object and its location.
		def create
			quiz = Quiz.new(quiz_params)
			if quiz.save
				current_instructor.quizzes << quiz
				render json: { success: true, data:{:quiz => quiz}, info:{} }, status: 201
			else
				render json: { success: false, data:{}, :info => quiz.errors }, status: 422
			end
		end
		#This method publishes a quiz by taking the group id and quiz id
		def publish
			quiz = Quiz.find(params[:id])
			group = Group.find(params[:group_id])
			quiz.publish(params[:group_id])
			if (group.quizzes.include?(quiz))
				render json: { success: true, data:{:quiz => quiz}, info:{} }, status: 201
			else
				render json: { success: false, data:{}, :info => "quiz isn't published" }, status: 422
			end
		end
		#This method deletes the quiz and the corresponding questions
		def destroy
			if (Quiz.exists?(:id => params[:id]))
				quiz = Quiz.find(params[:id])
				quiz.questions.each do |question|
					question.destroy
				end
				quiz.destroy
				head 204
			else
				render json: { success: false, data:{}, info:"Quiz is not found"}, status: 404
			end		
		end
		private
		def quiz_params
			params.require(:quiz).permit(:name, :subject, :duration, :no_of_MCQ, :no_of_rearrangeQ)
		end
	end
end