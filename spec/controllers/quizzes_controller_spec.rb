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
	    	expect(quiz_response[:success]).to eql(true)
	     	expect((quiz_response[:data][:quizzes]).first[:name]).to eql(@quiz.name)
	    end
    end

 	describe "student_show method succeeding" do
	    it "returns a specific quiz and its questions" do
	    	sign_in @student
	    	@quiz = create(:quiz)
	    	@quiz.update(expiry_date: DateTime.now - 1.hour)
	    	@question = create(:question)
	    	@quiz.questions << @question
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
	    	@question = create(:question)
	    	@quiz.questions << @question
	    	@student.quizzes << @quiz
	    	get :student_show, id: 25
	    	quiz_response = json(response.body)
	    	expect(response.status).to eq(404)
	     	expect(quiz_response[:success]).to eql(false)
	     	expect(quiz_response[:info]).to eql("Quiz is not found")	
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
	    	expect(quiz_response[:success]).to eql(true)
	     	expect((quiz_response[:data][:quizzes]).first[:name]).to eql(@quiz.name)
	    end
    end

 	describe "instructor_show method succeeding" do
	    it "returns a specific quiz and its questions" do
	    	sign_in @instructor
	    	@quiz = create(:quiz)
	    	@question = create(:question)
	    	@quiz.questions << @question
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
	    	@question = create(:question)
	    	@quiz.questions << @question
	    	@instructor.quizzes << @quiz
	    	get :instructor_show, id: 25
	    	quiz_response = json(response.body)
	    	expect(response.status).to eq(404)
	     	expect(quiz_response[:success]).to eql(false)
	     	expect(quiz_response[:info]).to eql("Quiz is not found")	
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

    describe "delete method succeeding" do
	    it "deletes a quiz from the instructor quizzes" do
	    	sign_in @instructor
	    	@quiz = create(:quiz)
	    	@question = create(:question)
	    	@quiz.questions << @question
	    	@instructor.quizzes << @quiz
	    	delete :destroy, id: @quiz.id
	    	quiz_response = json(response.body)
	    	expect(response.status).to eq(200)
	     	expect(quiz_response[:success]).to eql(true)
	     	expect(quiz_response[:info]).to eql("Quiz is successfully deleted.")
	     	expect(Quiz.find_by_id(@quiz.id)).to eql(nil)
	     	expect(Question.find_by_id(@question.id)).to eql(nil)		
	    end
    end

    describe "delete method succeeding" do
	    it "deletes a quiz from the instructor quizzes" do
	    	sign_in @instructor
	    	@quiz = create(:quiz)
	    	@question = create(:question)
	    	@quiz.questions << @question
	    	@instructor.quizzes << @quiz
	    	delete :destroy, id: 2
	    	quiz_response = json(response.body)
	    	expect(response.status).to eq(404)
	     	expect(quiz_response[:success]).to eql(false)
	     	expect(quiz_response[:info]).to eql("Quiz is not found.")
	     	expect(Quiz.find_by_id(@quiz.id)).to eql(@quiz)
	     	expect(Question.find_by_id(@question.id)).to eql(@question)		
	    end
    end

    describe "publish method succeeding" do
	    it "publishes a quiz from the instructor quizzes to a future date and time" do
	    	sign_in @instructor
	    	@quiz = create(:quiz)
	    	@group = create(:group)
	    	@group.students << @student
	    	@instructor.quizzes << @quiz
	    	@instructor.groups << @group
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
	    	@quiz = create(:quiz)
	    	@group = create(:group)
	    	@group.students << @student
	    	@instructor.quizzes << @quiz
	    	@instructor.groups << @group
	    	post :publish, { id: @quiz.id, group_id: @group.id, expiry_date: (DateTime.now - 1.day).to_s}
	    	quiz_response = json(response.body)
	    	expect(response.status).to eq(422)
	     	expect(quiz_response[:info]).to eql("Expiry Date must be in the future.")
	     	expect(@group.quizzes.find_by_id(@quiz.id)).to eql(nil)
	     	expect(@student.quizzes.find_by_id(@quiz.id)).to eql(nil)		
	    end
    end
end
