module Api
	class QuizzesController < ApplicationController
		acts_as_token_authentication_handler_for Instructor, except: [:student_index,:student_show,:student_take_quiz,:mark_quiz]
		acts_as_token_authentication_handler_for Student, only: [:student_index,:student_show , :student_take_quiz,:mark_quiz]
		respond_to :json
		#This method returns to the student list of her/his quizzes.
		def student_index
			quizzes = current_student.quizzes
			render json: { success:true, data:{:quizzes => quizzes}, info:{} }, status: 200
		end
		#This method is used to get a specific quiz by taking the quiz id from the student.
		def student_show
			if (current_student.quizzes.exists?(:id => params[:id]))
				quiz = current_student.quizzes.find(params[:id])
				questions = quiz.questions
				render json: {success:true, data:{:quiz => quiz, :questions => questions, info:{}} }, status: 200
			else
				render json: { success: false, data:{}, info:"Quiz is not found"}, status: 404
			end
		end
		#This method returns to the instructor list of her/his quizzes.
		def instructor_index
			quizzes = current_instructor.quizzes
			render json: { success:true, data:{:quizzes => quizzes},info:{} }, status: 200
		end
		#This method is used to get a specific quiz by taking the quiz id from the instructor.
		def instructor_show
			if (current_instructor.quizzes.exists?(:id => params[:id]))
				quiz = current_instructor.quizzes.find(params[:id])
				questions = quiz.questions
				render json: {success:true, data:{:quiz => quiz, :questions => questions, info:{}} }, status: 200
			else
				render json: { success: false, data:{}, info:"Quiz is not found"}, status: 404
			end
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
			if(current_instructor.quizzes.exists?(:id => params[:id]))
				if(current_instructor.groups.exists?(:id => params[:group_id]))
					quiz = Quiz.find(params[:id])
					group = Group.find(params[:group_id])
					quiz.publish_quiz(params[:group_id])
					if (group.quizzes.include?(quiz))
						render json: { success: true, data:{:quiz => quiz}, info:{} }, status: 202
					else
						render json: { success: false, data:{}, info: "Quiz is not published." }, status: 422
					end
				else
					render json: { success: false, data: {}, info: "Group is not found" }, status: 404
				end	
			else
				render json: { success: false, data: {}, info: "Quiz is not found" }, status: 404
			end
		end
		#This method deletes the quiz and the corresponding questions
		def destroy
			if (current_instructor.quizzes.exists?(:id => params[:id]))
				quiz = Quiz.find(params[:id])
				quiz.questions.each do |question|
					question.destroy
				end
				quiz.destroy
				render json: { success: true, data:{}, :info => "Quiz is successfully deleted." }, status: 200
			else
				render json: { success: false, data:{}, info:"Quiz is not found"}, status: 404
			end		
		end
		#This method creates new question by taking the question attributes attributes from JSON object
		#and assigns this question to the current quiz using the sent quiz id.  
		#and it returns the JSON representation of the newly created object.
		def add_question
			question = Question.new(question_params)
			if (current_instructor.quizzes.exists?(:id => params[:quiz_id]))
				quiz = Quiz.find(params[:quiz_id])
				if question.save
					quiz.questions << question
					render json: { success: true, data:{:question => question}, info:{} }, status: 201
				else
					render json: { success: false, data:{}, :info => question.errors }, status: 422
				end
			else
				render json: { success: false, data:{}, info:"Quiz is not found"}, status: 422
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
					render json: { success: false, data: {}, info: question.errors}, status: 422 
				end	
			else
				render json: { success: false, data:{}, info:"Question is not found"}, status: 422
			end
		end


		def student_take_quiz
         
         quiz = Quiz.find_by_id(params[:id])
         quiz_groups = quiz.groups 
         student_groups = current_student.groups
         found = 0
         quiz_groups.each do|quiz_group|
             if(student_groups.include?(quiz_group))
                found =1	
             end
         end
         if (found==0)
        	 render status: 404,
              	    json: { success: false,
                         info: "Quiz not found or not allowed to you",
                         data: {} }

         else
         	 render status: 200,
               	    json: { success: true,
                         info: "Quiz returned",
                         data: { quiz: quiz} }

         end 


        

		
        
		end	

    def mark_quiz
        
        my_quiz = Quiz.find_by_id(params[:answers_stuff][:quiz_id])
        my_answers = params[:answers_stuff][:answers]
        if((my_quiz == nil) || (current_student==nil) || (my_answers==nil))
        	render status: 404 , 
        		   json: { success: false,
                         info: "necessary parameters not found"
                    	 }
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
                	   json: { success: false,
                       			  info: "Quiz not allowed to you",
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
        		current_student_result_quiz = StudentResultQuiz.new
        		current_student_result_quiz.student = current_student
        		current_student_result_quiz.quiz = my_quiz
        		current_student_result_quiz.result = my_result 
        		current_student_result_quiz.student_ans =my_answers
        		current_student_result_quiz.save
       			if(current_student_result_quiz.save)
      	 			render status: 200 , 
            			   json: { success: true,
                         			  info: "Saved in the database ",
                         	   your_answer: current_student_result_quiz.student_ans 
                          			}
        		else
        		  render status: 422 , 
            			   json: { success: false,
                           info: "couldn't save in database ",
                           result: my_result
                          }
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