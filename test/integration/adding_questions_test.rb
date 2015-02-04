class AddingQuestionsTest < ActionDispatch::IntegrationTest	
	setup {@quiz = Quiz.create(name: 'Quiz1', subject: 'physics', duration: 10, no_of_MCQ: 5, no_of_rearrangeQ: 5)}
	setup {@question = Question.create(text: "Question Text Example", mark: 2, choices:["a","b","c","d"], right_answer: "a")}	
	
	test 'successes to add question to a quiz' do		
 		post "api/quizzes/addquestion/#{@quiz.id}",
 		{ question:	
	 	{ text: "Question Text Example", mark: 2, choices:["a","b","c","d"], right_answer: "a" }	
		}.to_json,
 		{ 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }		
		question_response = json(response.body)
		assert_equal 201, response.status	
		assert_equal @quiz.questions.first.choices, @question.choices
		assert_equal question_response[:success], true
	end			
end