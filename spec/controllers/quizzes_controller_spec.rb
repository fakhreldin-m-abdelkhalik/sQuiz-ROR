require 'rails_helper'
require 'spec_helper'

RSpec.describe Api::QuizzesController, :type => :controller do
	before (:each) do
        @instructor = create(:instructor)
        @student = create(:student)
	end

	describe "student_index method" do
	    it "returns all quizzes of the current student" do
	    	sign_in @student
	    	@quiz = create(:quiz)
	    	@student.quizzes << @quiz
	    	get :student_index
	    	quiz_response = json(response.body)
	    	expect(response.status).to eq(200)
	     	expect(quiz_response.as_json[0]["name"]).to eql(@quiz.name)
	     	expect(quiz_response.as_json[0]["id"]).to eql(@quiz.id)
	    end
    end

 	describe "student_show method succeeding" do
	    it "returns a specific quiz and its questions" do
	    	sign_in @student
	    	@quiz = create(:quiz)
	    	@quiz.update(expiry_date: DateTime.now - 1.hour)
	    	assign_create_question
	    	@student.quizzes << @quiz
	    	get :student_show, id: @quiz.id
	    	quiz_response = json(response.body)
	    	expect(response.status).to eq(200)
	    	expect(quiz_response[:success]).to eql(true)
	     	expect(quiz_response[:data][:quiz][:name]).to eql(@quiz.name)
	     	expect((quiz_response[:data][:questions]).first[:text]).to eql(@question.text)	
	    end
    end

    describe "student_show method failing" do
	    it "returns a specific quiz and its questions" do
	    	sign_in @student
	    	@quiz = create(:quiz)
	    	assign_create_question
	    	@student.quizzes << @quiz
	    	get :student_show, id: 25
	    	quiz_response = json(response.body)
	    	expect(response.status).to eq(404)
	     	expect(quiz_response[:error]).to eql("Quiz is not found")	
	    end
    end
    
    describe "instructor_index method" do
	    it "returns all quizzes of the current instructor" do
	    	sign_in @instructor
	    	@quiz = create(:quiz)
	    	@instructor.quizzes << @quiz
	    	get :instructor_index
	    	quiz_response = json(response.body)
	    	expect(response.status).to eq(200)
	     	expect(quiz_response.as_json[0]["name"]).to eql(@quiz.name)
	     	expect(quiz_response.as_json[0]["id"]).to eql(@quiz.id)
	    end
    end

 	describe "instructor_show method succeeding" do
	    it "returns a specific quiz and its questions" do
	    	sign_in @instructor
	    	@quiz = create(:quiz)
	    	assign_create_question
	    	@instructor.quizzes << @quiz
	    	get :instructor_show, id: @quiz.id
	    	quiz_response = json(response.body)
	    	expect(response.status).to eq(200)
	    	expect(quiz_response[:success]).to eql(true)
	     	expect(quiz_response[:data][:quiz][:name]).to eql(@quiz.name)
	     	expect((quiz_response[:data][:questions]).first[:text]).to eql(@question.text)	
	    end
    end

    describe "instructor_show method failing" do
	    it "returns a specific quiz and its questions" do
	    	sign_in @instructor
	    	@quiz = create(:quiz)
	    	assign_create_question
	    	@instructor.quizzes << @quiz
	    	get :instructor_show, id: 25
	    	quiz_response = json(response.body)
	    	expect(response.status).to eq(404)
	     	expect(quiz_response[:error]).to eql("Quiz is not found")	
	    end
    end

    describe "create method succeeding" do
	    it "creates a new quiz for the current instructor" do
	    	sign_in @instructor
	    	post :create, quiz: { name:"quiz1", subject:"maths", duration: 10, no_of_MCQ: 5, no_of_rearrangeQ: 5 }
	    	quiz_response = json(response.body)
	    	expect(response.status).to eq(201)
	     	expect(quiz_response[:success]).to eql(true)
	     	expect(quiz_response[:data][:quiz][:name]).to eql("quiz1")	
	     	expect(quiz_response[:data][:quiz][:subject]).to eql("maths")	
	     	expect(quiz_response[:data][:quiz][:duration]).to eql(10)	
	     	expect(quiz_response[:data][:quiz][:no_of_MCQ]).to eql(5)
	     	expect(quiz_response[:data][:quiz][:no_of_rearrangeQ]).to eql(5)	
	    end
    end

    describe "create method failing" do
	    it "fails to create a new quiz for the current instructor due to validations" do
	    	sign_in @instructor
	    	post :create, quiz: { name:"", subject:"maths", duration: 10, no_of_MCQ: 5, no_of_rearrangeQ: 5 }
	    	quiz_response = json(response.body)
	    	expect(response.status).to eq(422)	
	    end
    end

    # describe "delete method succeeding" do
	   #  it "deletes a quiz from the instructor quizzes" do
	   #  	sign_in @instructor
	   #  	@quiz = create(:quiz)
	   #  	assign_create_question
	   #  	@instructor.quizzes << @quiz
	   #  	delete :destroy, id: @quiz.id
	   #  	quiz_response = json(response.body)
	   #  	expect(response.status).to eq(200)
	   #   	expect(quiz_response[:success]).to eql(true)
	   #   	expect(quiz_response[:error]).to eql("Quiz is successfully deleted.")
	   #   	expect(Quiz.find_by_id(@quiz.id)).to eql(nil)
	   #   	expect(Question.find_by_id(@question.id)).to eql(nil)		
	   #  end
    # end

    # describe "delete quiz method failing" do
	   #  it "fails to delete a quiz from the instructor quizzes" do
	   #  	sign_in @instructor
	   #  	@quiz = create(:quiz)
	   #  	assign_create_question
	   #  	@instructor.quizzes << @quiz
	   #  	delete :destroy, id: 2
	   #  	quiz_response = json(response.body)
	   #  	expect(response.status).to eq(404)
	   #   	expect(quiz_response[:error]).to eql("Quiz is not found.")
	   #   	expect(Quiz.find_by_id(@quiz.id)).to eql(@quiz)
	   #   	expect(Question.find_by_id(@question.id)).to eql(@question)		
	   #  end
    # end

    describe "publish method succeeding" do
	    it "publishes a quiz from the instructor quizzes to a future date and time" do
	    	sign_in @instructor
			assign_create_quiz_group
	    	@group.students << @student
	    	post :publish, { id: @quiz.id, group_id: @group.id, expiry_date: (DateTime.now + 1.day).to_s}
	    	quiz_response = json(response.body)
	    	expect(response.status).to eq(202)
	     	expect(quiz_response[:success]).to eql(true)
	     	expect(@group.quizzes.find_by_id(@quiz.id)).to eql(@quiz)
	     	expect(@student.quizzes.find_by_id(@quiz.id)).to eql(@quiz)		
	    end
    end

    describe "publish method failing" do
	    it "fails to publish a quiz from the instructor quizzes because the instructor specifies past time" do
	    	sign_in @instructor
	    	assign_create_quiz_group
	    	@group.students << @student
	    	post :publish, { id: @quiz.id, group_id: @group.id, expiry_date: (DateTime.now - 1.day).to_s}
	    	quiz_response = json(response.body)
	    	expect(response.status).to eq(422)
	     	expect(quiz_response[:error]).to eql("Expiry Date must be in the future.")
	     	expect(@group.quizzes.find_by_id(@quiz.id)).to eql(nil)
	     	expect(@student.quizzes.find_by_id(@quiz.id)).to eql(nil)		
	    end
    end

    describe "add question method succeeding" do
	    it "adds question to a specific quiz" do
	    	sign_in @instructor
	    	assign_create_quiz_group
	    	@group.students << @student
	    	post :add_question, { quiz_id: @quiz.id, question: {text: "Example Question?", mark: 2, right_answer: "a", choices: ["a","b","c","d"]}}
	    	quiz_response = json(response.body)
	    	expect(response.status).to eq(201)
	     	expect(quiz_response[:data][:question][:text]).to eql("Example Question?")		
	    	expect(quiz_response[:data][:question][:mark]).to eql(2.0)
	    	expect(quiz_response[:data][:question][:choices]).to eql(["a","b","c","d"])
	    	expect(quiz_response[:data][:question][:right_answer]).to eql("a")
	    end
    end

    describe "add question method failing" do
	    it "fails to add question to a specific quiz due to validations failure" do
	    	sign_in @instructor
	    	assign_create_quiz_group	
	    	@group.students << @student
	    	post :add_question, { quiz_id: @quiz.id, question: {text: "", mark: 2, right_answer: "a", choices: ["a","b","c","d"]}}
	    	quiz_response = json(response.body)
	    	expect(response.status).to eq(422)
	    	expect(quiz_response[:error][:text]).to eq(["can't be blank"])
	    end
    end

    describe "edit question method succeeding" do
	    it "change any of the attributes of the question " do
	    	sign_in @instructor
	    	assign_create_quiz_group
	    	assign_create_question
	    	patch :edit_question, { question_id: @question.id, question: {choices: ["abcd","efgh","hijk","lmnop"]}}
	    	quiz_response = json(response.body)
	    	expect(response.status).to eq(200)
	    	expect(quiz_response[:data][:question][:choices]).to eql(["abcd","efgh","hijk","lmnop"])
	    	expect(quiz_response[:data][:question][:right_answer]).to eql("a")
	    end
    end

    describe "edit question method failing" do
	    it "fails to change the attribute of the question due to validations" do
	    	sign_in @instructor
	    	assign_create_quiz_group
	    	assign_create_question
	    	patch :edit_question, { question_id: @question.id, question: {choices: []}}
	    	quiz_response = json(response.body)
	    	expect(response.status).to eq(422)
	    	expect(quiz_response[:error][:choices]).to eq(["can't be blank"])
	    end
    end

    describe "mark_quiz method succeeding"do
    	it "succeeds to mark the quiz and return the student his answers" do
          sign_in @student 
          assign_create_quiz_group
          
          @question_1 = create(:question)
          @question_2 = create(:question)
          @question_3 = create(:question2)
          @quiz.questions << @question_1
          @quiz.questions << @question_2
          @quiz.questions << @question_3
          @group.students << @student
          @quiz.publish_quiz(@group.id)

          post :mark_quiz , answers_stuff:{quiz_id:@quiz.id ,answers:["a","b","c"]}

          quiz_response = json(response.body)
          expect(response.status).to eq(200)
          expect(quiz_response[:your_answer]).to eql(["a","b","c"])





    	end
    end	

    describe "mark_quiz method failing_1 Answers not properly sent"do
    	it "fails to proceed because answers sent from Android are not fine" do
 		  sign_in @student 
          assign_create_quiz_group

 		  @question_1 = create(:question)
          @question_2 = create(:question)
          @question_3 = create(:question2)
          @quiz.questions << @question_1
          @quiz.questions << @question_2
          @quiz.questions << @question_3
          @group.students << @student
          @quiz.publish_quiz(@group.id)

          post :mark_quiz , answers_stuff:{quiz_id:@quiz.id}

          quiz_response = json(response.body)
          expect(response.status).to eq(404)
          expect(quiz_response[:error]).to eq("answers not properly sent")
          

    	end
    end		




    describe "mark_quiz method failing_2 Quiz not found"do
    	it "fails to proceed because quiz isn't found " do
 		  sign_in @student 
          assign_create_quiz_group

 		  @question_1 = create(:question)
          @question_2 = create(:question)
          @question_3 = create(:question2)
          @quiz.questions << @question_1
          @quiz.questions << @question_2
          @quiz.questions << @question_3
          @group.students << @student
          @quiz.publish_quiz(@group.id)

          post :mark_quiz , answers_stuff:{quiz_id:3 ,answers:["a","b","c"]}

          quiz_response = json(response.body)
          expect(response.status).to eq(404)
          expect(quiz_response[:error]).to eq("Quiz Not Found")
          

    	end
    end	


    describe "mark_quiz method failing_3 Quiz not allowed to student"do
    	it "fails to proceed because quiz not allowed to student " do
 		  sign_in @student 
          assign_create_quiz_group

 		  @question_1 = create(:question)
          @question_2 = create(:question)
          @question_3 = create(:question2)
          @quiz.questions << @question_1
          @quiz.questions << @question_2
          @quiz.questions << @question_3
          #@group.students << @student
          @quiz.publish_quiz(@group.id)

          post :mark_quiz , answers_stuff:{quiz_id:@quiz.id ,answers:["a","b","c"]}

          quiz_response = json(response.body)
          expect(response.status).to eq(404)
          expect(quiz_response[:error]).to eq("Quiz not allowed to you")
          

    	end
    end	 

    describe "group_result method succeeding"do
    	it "returns quiz results for a group for current instructor" do
          sign_in @instructor
          assign_create_quiz_group
          
          @question_1 = create(:question)
          @question_2 = create(:question)
          @question_3 = create(:question2)
          @quiz.questions << @question_1 
          @quiz.questions << @question_2
          @quiz.questions << @question_3
          @group.students << @student
          @quiz.publish_quiz(@group.id)
          post :mark_quiz , answers_stuff:{quiz_id:@quiz.id ,answers:["a","b","c"]}
          post :group_result , quiz_id: @quiz.id , group_id: @group.id
          quiz_response = json(response.body)
          expect(response.status).to eq(200)
          expect(quiz_response[:success]).to eq(true)
    	end
    end	

	describe "group_result method succeeding - no group"do
    	it "fails to return quiz results for a group for current instructor" do
          sign_in @instructor
          assign_create_quiz_group
          
          @question_1 = create(:question)
          @question_2 = create(:question)
          @question_3 = create(:question2)
          @quiz.questions << @question_1 
          @quiz.questions << @question_2
          @quiz.questions << @question_3
          @group.students << @student
          @quiz.publish_quiz(@group.id)
          post :mark_quiz , answers_stuff:{quiz_id:@quiz.id ,answers:["a","b","c"]}
          post :group_result , quiz_id: @quiz.id , group_id: 5
          quiz_response = json(response.body)
          expect(response.status).to eq(422)
          expect(quiz_response[:success]).to eq(false)
          expect(quiz_response[:info]).to eq("Group does not exist")
    	end
    end	  

    describe "group_result method succeeding - no quiz"do
    	it "fails to return quiz results for a group for current instructor" do
          sign_in @instructor
          assign_create_quiz_group
          
          @question_1 = create(:question)
          @question_2 = create(:question)
          @question_3 = create(:question2)
          @quiz.questions << @question_1 
          @quiz.questions << @question_2
          @quiz.questions << @question_3
          @group.students << @student
          @quiz.publish_quiz(@group.id)
          post :mark_quiz , answers_stuff:{quiz_id:@quiz.id ,answers:["a","b","c"]}
          post :group_result , quiz_id: 4 , group_id: @group.id
          quiz_response = json(response.body)
          expect(response.status).to eq(422)
          expect(quiz_response[:success]).to eq(false)
          expect(quiz_response[:info]).to eq("Quiz does not exist")
    	end
    end	  

end

def assign_create_quiz_group
	@quiz = create(:quiz)
	@group = create(:group)
	@instructor.quizzes << @quiz
	@instructor.groups << @group
end

def assign_create_question
	@question = create(:question)
	@quiz.questions << @question
end