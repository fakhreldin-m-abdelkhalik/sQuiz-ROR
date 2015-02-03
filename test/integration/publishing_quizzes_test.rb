class PublishingQuizTest < ActionDispatch::IntegrationTest	
	setup { @quiz = Quiz.create(name: 'Quiz1', subject: 'physics', duration: 10, no_of_MCQ: 5, no_of_rearrangeQ: 5)}
	setup {@group = Group.create(name: 'class1') }	
	
	test 'successes to publish a quiz' do		
 		post "/api/quizzes/publish/#{@quiz.id}",
 		{:group_id => @group.id}.to_json,
 		{ 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }		
		publish_response = json(response.body)
		assert_equal 202, response.status	
		assert_equal @group.quizzes.first, @quiz
		assert_equal publish_response[:success], true
		assert_equal publish_response[:data][:quiz][:name], @quiz.name
	end			
end
