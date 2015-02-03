class DeletingQuizzesTest < ActionDispatch::IntegrationTest	
	setup { @quiz = Quiz.create(name: 'Quiz1', subject: 'physics', duration: 10, no_of_MCQ: 5, no_of_rearrangeQ: 5) }
	
	test 'deletes quiz' do
		delete "api/quizzes/#{@quiz.id}"
		assert_equal 204,response.status
	end
	test 'fails to delete quiz' do
		delete "api/quizzes/#{@quiz.id+1}"
		assert_equal 404,response.status
		quiz_response = json(response.body)
		assert_equal "Quiz is not found", quiz_response[:info]
		assert_equal false, quiz_response[:success]
	end
end