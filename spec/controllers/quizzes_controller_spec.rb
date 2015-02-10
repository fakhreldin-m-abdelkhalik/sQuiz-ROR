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
end
