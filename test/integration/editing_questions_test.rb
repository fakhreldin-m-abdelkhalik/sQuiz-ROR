class EditingQuestionsTest < ActionDispatch::IntegrationTest	
	setup {@question = Question.create(text: "Question Text Example", mark: 2, choices:["a","b","c","d"], right_answer: "a")}	
	test 'successes to add question to a quiz' do		
 		patch "api/quizzes/editquestion/#{@question.id}",
 		{ question:	
	 	{ text: "Question Text Example edited", mark: 3, choices:["d","c","b","a"], right_answer: "d" }	
		}.to_json,
 		{ 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }		
		question_response = json(response.body)
		assert_equal 200, response.status	
		assert_equal Question.find(@question.id).choices, ["d","c","b","a"]
		assert_equal question_response[:success], true
	end			
end