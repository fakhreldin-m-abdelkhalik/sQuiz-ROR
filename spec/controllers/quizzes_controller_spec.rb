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

 	describe "student_show method" do
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

    it "fails to return a specific quiz and its questions because quiz is not found" do
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

 	describe "instructor_show method" do
	    it "returns a specific quiz and its questions" do
	    	sign_in @instructor
	    	@quiz = create(:quiz)
	    	assign_create_question
	    	@instructor.quizzes << @quiz
	    	get :instructor_show, id: @quiz.id
	    	quiz_response = json(response.body)
	    	expect(response.status).to eq(200)
	     	expect(quiz_response.as_json[0]["text"]).to eql(@question.text)
	     	expect(quiz_response.as_json[0]["mark"]).to eql(@question.mark)
        expect(quiz_response.as_json[0]["choices"]).to eql(@question.choices)
        expect(quiz_response.as_json[0]["right_answer"]).to eql(@question.right_answer)	
	    end

      it "fails to return a specific quiz and its questions because quiz is not found" do
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

  describe "create method" do
    it "creates a new quiz for the current instructor" do
    	sign_in @instructor
    	post :create, quiz: { name:"quiz1", subject:"maths", duration: 10, no_of_MCQ: 5, no_of_rearrangeQ: 5 }
    	quiz_response = json(response.body)
    	expect(response.status).to eq(201)
    end

    it "fails to create a new quiz for the current instructor due to validations" do
      sign_in @instructor
      post :create, quiz: { name:"", subject:"maths", duration: 10, no_of_MCQ: 5, no_of_rearrangeQ: 5 }
      quiz_response = json(response.body)
      expect(response.status).to eq(422)  
    end
  end

  describe "delete method succeeding" do
    it "deletes a quiz from the instructor quizzes" do
    	sign_in @instructor
    	@quiz = create(:quiz)
      @quiz2 = create(:quiz2)
    	assign_create_question
      assign_create_question_2
    	@instructor.quizzes << @quiz
      @instructor.quizzes << @quiz2
    	post :destroy, _json: [{id: @quiz.id},{id: @quiz2.id}]
    	quiz_response = json(response.body)
    	expect(response.status).to eq(200)
     	expect(quiz_response[:info]).to eql("deleted")
     	expect(Quiz.find_by_id(@quiz.id)).to eql(nil)
      expect(Question.find_by_id(@question2.id)).to eql(nil)
     	expect(Question.find_by_id(@question.id)).to eql(nil)		
    end
  end

  describe "publish method" do
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

  describe "add_question method" do
    it "adds question to a specific quiz" do
    	sign_in @instructor
    	assign_create_quiz_group
    	post :add_question, quiz_id: @quiz.id, _json: [{text: "Example Question?", mark: 2, right_answer: "a", choices: ["a","b","c","d"]},
    	{text: "Example Question No 2?", mark: 10, right_answer: "d", choices: ["a","b","c","d"]}]
    	quiz_response = json(response.body)
    	expect(response.status).to eq(201)
     	expect(quiz_response[:info]).to eql("created")
     	expect(@quiz.questions.first.text).to eql("Example Question?")		
    	expect(@quiz.questions.first.mark).to eql(2.0)
    	expect(@quiz.questions.first.choices).to eql(["a","b","c","d"])
    	expect(@quiz.questions.first.right_answer).to eql("a")
    	expect(@quiz.questions.second.text).to eql("Example Question No 2?")		
    	expect(@quiz.questions.second.mark).to eql(10.0)
    	expect(@quiz.questions.second.choices).to eql(["a","b","c","d"])
    	expect(@quiz.questions.second.right_answer).to eql("d")
    end

    it "fails to add question to a specific quiz due to not found quiz" do
      sign_in @instructor
      assign_create_quiz_group
      post :add_question, quiz_id: 25, _json: [{text: "Example Question?", mark: 2, right_answer: "a", choices: ["a","b","c","d"]},
      {text: "Example Question No 2?", mark: 10, right_answer: "d", choices: ["a","b","c","d"]}]
      quiz_response = json(response.body)
      expect(response.status).to eq(422)
      expect(quiz_response[:error]).to eql("Quiz is not found")
    end
  end

  describe "edit question method" do
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

  describe "mark_quiz method"do
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

    it "fails to proceed because quiz not allowed to student " do
      sign_in @student 
      assign_create_quiz_group

      @question_1 = create(:question)
      @question_2 = create(:question)
      @question_3 = create(:question2)
      @quiz.questions << @question_1
      @quiz.questions << @question_2
      @quiz.questions << @question_3
      @quiz.publish_quiz(@group.id)

      post :mark_quiz , answers_stuff:{quiz_id:@quiz.id ,answers:["a","b","c"]}

      quiz_response = json(response.body)
      expect(response.status).to eq(404)
      expect(quiz_response[:error]).to eq("Quiz not allowed to you")
    end
  end		

  describe "instructor_student_mark"do
  	it "returns the mark of a certian student " do
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
      @quiz.expiry_date = "2001-02-20 11:25:09 +0200".to_datetime
      @quiz.save 
      post :mark_quiz , answers_stuff:{quiz_id:@quiz.id ,answers:["a","b","c"]}
      quiz_response = json(response.body)
      expect(response.status).to eq(200)
  	  sign_in @instructor
      get :instructor_student_mark ,quiz_id:@quiz.id ,student_id:@student.id
      quiz_response = json(response.body)
      expect(response.status).to eq(200)
      expect(quiz_response[:data][:result]).to eq(5.5)
  	end

    it "fails due to quiz not found" do
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
      @quiz.expiry_date = "2001-02-20 11:25:09 +0200".to_datetime
      @quiz.save 
      post :mark_quiz , answers_stuff:{quiz_id:@quiz.id ,answers:["a","b","a"]}
      quiz_response = json(response.body)
      expect(response.status).to eq(200) 
      sign_in @instructor
      get :instructor_student_mark ,quiz_id: 2 ,student_id:@student.id
      quiz_response = json(response.body)
      expect(response.status).to eq(404)
      expect(quiz_response[:error]).to eq("Quiz Not Found")
    end

    it "fails due to quiz hasn't expired yet" do
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
      @quiz.expiry_date = "2020-02-20 11:25:09 +0200".to_datetime
      @quiz.save 
      post :mark_quiz , answers_stuff:{quiz_id:@quiz.id ,answers:["a","b","a"]}
      quiz_response = json(response.body)
      expect(response.status).to eq(200)
      sign_in @instructor
      get :instructor_student_mark ,quiz_id:@quiz.id ,student_id:@student.id
      quiz_response = json(response.body)
      expect(response.status).to eq(200)
      expect(quiz_response[:error]).to eq("Quiz hasn't expired yet")
    end

    it "fails::Student not allowed this quiz " do
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
      @quiz.expiry_date = "2002-02-20 11:25:09 +0200".to_datetime
      @quiz.save 
      post :mark_quiz , answers_stuff:{quiz_id:@quiz.id ,answers:["a","b","a"]}
      quiz_response = json(response.body)
      expect(response.status).to eq(200)
      sign_in @instructor
      student2=create(:student2)
      student3=create(:student3)
      get :instructor_student_mark ,quiz_id:@quiz.id ,student_id: 2
      quiz_response = json(response.body)
      expect(quiz_response[:error]).to eq("Student not allowed this quiz")
    end

    it "fails::Instructor didn't create this Quiz " do
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
      @quiz.expiry_date = "2002-02-20 11:25:09 +0200".to_datetime
      @quiz.save 
      post :mark_quiz , answers_stuff:{quiz_id:@quiz.id ,answers:["a","b","a"]}
      quiz_response = json(response.body)
      expect(response.status).to eq(200)
      @instructor_2 = create(:instructor1)
      sign_in @instructor_2
      student2=create(:student2)
      student3=create(:student3)
      get :instructor_student_mark ,quiz_id:@quiz.id ,student_id:@student.id
      quiz_response = json(response.body)
      expect(quiz_response[:error]).to eq("You don't own this Quiz as an instructor")
    end

    describe "group_result method "do
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

def assign_create_question_2
  @question2 = create(:question2)
  @quiz2.questions << @question2
end