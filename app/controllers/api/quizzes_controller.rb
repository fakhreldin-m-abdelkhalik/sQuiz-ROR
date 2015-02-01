module Api
	class QuizzesController < ApplicationController
		#This method is used to get quiz by taking the quiz id from the client.
		def show
			quiz = Quiz.find(params[:id])
			render json: quiz, status: 200
		end
	end
end