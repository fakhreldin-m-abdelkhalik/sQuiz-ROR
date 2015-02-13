module Api
	class QuizzesController < ApplicationController
		acts_as_token_authentication_handler_for Instructor, except: [:student_index,:student_show,:student_take_quiz,:mark_quiz]
		acts_as_token_authentication_handler_for Student, only: [:student_index,:student_show , :student_take_quiz,:mark_quiz]
		respond_to :json
		#This method returns to the student list of her/his quizzes.
		def student_index
			quizzes = current_student.quizzes
			render json: quizzes.as_json(:only => [:name, :id, :created_at, :no_of_MCQ, :no_of_rearrangeQ]), status: 200
		end
		#This method is used to get a specific quiz by taking the quiz id from the student.
		def student_show
			if (current_student.quizzes.exists?(:id => params[:id]))
				quiz = current_student.quizzes.find(params[:id])
				if( quiz.expiry_date < DateTime.current )
					student_quiz_obj = StudentResultQuiz.where(student_id:current_student.id).where(quiz_id:quiz.id).first	
					answers = student_quiz_obj.student_ans
					student_result = student_quiz_obj.result
					questions = quiz.questions
					render json: {success:true, data:{:quiz => quiz, :questions => questions, :student_answers => answers, :result => student_result},info:{} }, status: 200
				else
					render json: { error:"Quiz hasn't expired yet."} , status: 200
				end
			else
				render json: { error:"Quiz is not found" }, status: 404
			end
		end
		#This method returns to the instructor list of her/his quizzes.
		def instructor_index
			quizzes = current_instructor.quizzes
			render json: quizzes.as_json(:only => [:id, :name, :created_at, :no_of_MCQ, :no_of_rearrangeQ]), status: 200
		end
		#This method is used to get a specific quiz by taking the quiz id from the instructor.
		def instructor_show
			if (current_instructor.quizzes.exists?(:id => params[:id]))
				quiz = current_instructor.quizzes.find(params[:id])
				questions = quiz.questions.order(created_at: :desc)
				render json: questions, status: 200
			else
				render json: { error:"Quiz is not found" }, status: 404
			end
		end
		#This method creates new quiz by taking the quiz attributes from JSON object 
		#and it returns the JSON representation of the newly created object and its location.
		def create
			quiz = Quiz.new(quiz_params)
			if quiz.save
				current_instructor.quizzes << quiz
				render json: { id: quiz.id }, status: 201
			else
				render json: { error: quiz.errors }, status: 422
			end
		end
		#This method publishes a quiz by taking the group id and quiz id
		def publish
			if(current_instructor.quizzes.exists?(:id => params[:id]))
				if(current_instructor.groups.exists?(:id => params[:group_id]))
					if((params[:expiry_date]).to_datetime > DateTime.current) 
						quiz = Quiz.find(params[:id])
						group = Group.find(params[:group_id])
						if (quiz.update(expiry_date: (params[:expiry_date]).to_datetime))
							quiz.publish_quiz(params[:group_id])
							render json: { success: true, data:{:quiz => quiz}, info:{} }, status: 202
						else
							render json: { error: quiz.errors }, status: 422
						end
					else
						render json: { error: "Expiry Date must be in the future." }, status: 422
					end
				else
					render json: { error: "Group is not found" }, status: 404
				end	
			else
				render json: { error: "Quiz is not found" }, status: 404
			end
		end
		#This method deletes the quiz and the corresponding questions
		def destroy
			ids = []
			i = 0

			while ( params["_json"][i] != nil ) do
				ids << (params["_json"][i]["id"]).to_i 
				i = i + 1
			end

			ids.each do |id|
				if (current_instructor.quizzes.exists?(:id => id))
					quiz = Quiz.find(id) 
					quiz.questions.each do |question|
						question.destroy
					end
					quiz.destroy
				end
			end
			render json: {info:"deleted"}, status: 200		
		end
		#This method creates new question by taking the question attributes attributes from JSON object
		#and assigns this question to the current quiz using the sent quiz id.  
		#and it returns the JSON representation of the newly created object.
		def add_question
			if(current_instructor.quizzes.exists?(:id => params[:quiz_id]))
				quiz = current_instructor.quizzes.find(params[:quiz_id])
				no = quiz.no_of_MCQ + quiz.no_of_rearrangeQ	
				no.times do |n|
					question = Question.create((params["_json"][n]).permit([:text, :mark, :right_answer, :choices => []]))
					quiz.questions << question
				end
				render json: { info: "created"}, status: 201
			else
				render json: { error:"Quiz is not found" }, status: 422
			end
		end

		#This methods edits a question in quiz by taking the desired new question attributes from JSON objec
		#and changes the current question atrributes.
		def edit_question
			quizzes = current_instructor.quizzes
			@found = 0
			quizzes.each do |quiz|
				if(quiz.questions.exists?(:id => params[:question_id]))
					@found = @found + 1
				end 
			end
			if (@found > 0)
				question = Question.find(params[:question_id])
				if (question.update(question_params))
					render json: { success: true, data: { :question => question }, info:{} }, status: 200
				else
					render json: { error: question.errors }, status: 422 
				end	
			else
				render json: { error:"Question is not found" }, status: 422
			end
		end

		def group_result
			group =  Group.find_by_id(params[:group_id])
			quiz = Quiz.find_by_id(params[:quiz_id])

			if(!group || group.instructor != current_instructor)
				render status: :unprocessable_entity,
             	json: { success: false,
                        info: "Group does not exist",
                        data: {} }  
			elsif(!quiz || quiz.instructor != current_instructor)
				render status: :unprocessable_entity,
             	json: { success: false,
                        info: "Quiz does not exist",
                        data: {} }  
			else
				list = quiz.student_result_quizzes
				return_result = {}
				grades = {}
				
				list.each do |student_result_quiz|
					if group.students.include?(student_result_quiz.student)
						id = student_result_quiz.student.id
						return_result[:name] = student_result_quiz.student.name
						return_result[:result] = student_result_quiz.result
						grades[id] = return_result
					end
				end

				render status: 200,
						json:{success: true , results: grades}
			end
		end


		def instructor_student_mark
        	my_quiz = Quiz.find_by_id(params[:quiz_id])
        	my_student = Student.find_by_id(params[:student_id])
        	if(my_quiz == nil)
        		render  status: 404 , 
            		    json: { error: "Quiz Not Found" } 

            elsif(my_student==nil) 
            	render  status: 404 , 
            		    json: { error: "Student not found" }              
        	elsif(current_instructor.quizzes.exists?(:id => my_quiz.id))
        		if(my_student.quizzes.exists?(:id => my_quiz.id))
        			puts my_quiz.expiry_date
        			if(my_quiz.expiry_date < DateTime.current )
						student_quiz_obj = StudentResultQuiz.where(student_id:my_student.id).where(quiz_id:my_quiz.id).first	
						answers = student_quiz_obj.student_ans
						student_result = student_quiz_obj.result
						questions = my_quiz.questions
						render json: {success:true, data:{:student_answers => answers, :result => student_result},info:"done !" }, status: 200
					else
						render json: { error: "Quiz hasn't expired yet" }  , status: 200
					end
        		else
        			render  status: 404 , 
            		   json: { error: "Student not allowed this quiz" } 
        		end	
        	else	
        		render  status: 404 , 
            		    json: { error: "You don't own this Quiz as an instructor" } 
        	end	
		end	



    	def mark_quiz
	        my_quiz = Quiz.find_by_id(params[:answers_stuff][:quiz_id])
	        my_answers = params[:answers_stuff][:answers]

	        if(my_quiz == nil)
	        	render status: 404 , 
	        		   json: { error: "Quiz Not Found" }

	        elsif(my_answers==nil)  
	        	render status: 404 , 
	        		   json: { error: "answers not properly sent" }
			else   
	        	my_quiz_questions = my_quiz.questions  
	        	quiz_groups = my_quiz.groups 
	         	student_groups = current_student.groups
	         	found = 0
	         	quiz_groups.each do|quiz_group|
	            	if(student_groups.include?(quiz_group))
	                found =1	
	              	end
	       		end
				if (found==0)
	         		render status: 404,
	                	   json: { 
	                       			error: "Quiz not allowed to you",
	                              }
				else                
	        		counter = 0 
	        		my_result =0
	        		my_quiz_questions.each do |question|
		         		if(my_answers[counter] == question.right_answer)
		          			my_result = my_result + question.mark 
		         		end
		         		counter = counter +1 
	        		end	
	        		current_student_result_quiz = StudentResultQuiz.where(student_id:current_student.id).where(quiz_id:my_quiz.id).first
	        		current_student_result_quiz.result = my_result 
	        		current_student_result_quiz.student_ans =my_answers
	       			if(current_student_result_quiz.save)
	      	 			render status: 200 , 
	            			   json: {
	                         	   		your_answer: current_student_result_quiz.student_ans
	                         	   	 }
	        		else
	        		  render status: 422 , 
	            			   json: { error: "couldn't save in database " }
	        		end                  
				end        
			end
		end	

		private
		def quiz_params
			params.require(:quiz).permit(:name, :subject, :duration, :no_of_MCQ, :no_of_rearrangeQ)
		end
		def question_params
			params.require(:question).permit(:text, :mark, :right_answer, :choices => [])
		end
	end
end