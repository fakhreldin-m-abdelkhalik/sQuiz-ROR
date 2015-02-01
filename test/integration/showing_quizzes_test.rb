class ShowingQuizzesTest < ActionDispatch::IntegrationTest
	setup { host! 'example.com' }
	
	test 'return quiz by id' do 
		quiz = Quiz.create(name: 'Quiz1', subject: 'physics', duration: 10, no_of_MCQ: 5, no_of_rearrangeQ: 5) 
		get "api/quizzes/#{quiz.id}"
		assert_equal 200, response.status

		quiz_response = json(response.body)
		assert_equal quiz.name, quiz_response[:name]
	end
end		