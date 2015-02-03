class ShowingQuizzesTest < ActionDispatch::IntegrationTest
	include Devise::TestHelpers
	setup { host! 'example.com' }
	test 'return quiz by id' do 
		instructor=Instructor.create(name:"same7", email:"abcdefg@eng.asu.edu.com", password:"123abc")
		sign_in instructor
		quiz = Quiz.create(name: 'Quiz1', subject: 'physics', duration: 10, no_of_MCQ: 5, no_of_rearrangeQ: 5) 
		current_instructor.quizzes << quiz
		get "api/quizzes/#{quiz.id}"
		assert_equal 200, response.status

		quiz_response = json(response.body)
		assert_equal quiz.name, quiz_response[:name]
	end
end		