class PublishingQuizTest < ActionDispatch::IntegrationTest	
	#setup { @quiz = Quiz.create(name: 'Quiz1', subject: 'physics', duration: 10, no_of_MCQ: 5, no_of_rearrangeQ: 5) }	
	
#	test 'success in publishing quiz' do		
 #   	patch "api/quizzes/#{@quiz.id}",	
			
#{ 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }	
#assert_equal 200, response.status	
#assert_equal 'First Title Edit', @episode.reload.title	
#end	
	#end	
	#test 'does not create quiz with name nil' do	
	#	post "/api/quizzes",	
	#	{ quiz:	
	#	{ name: nil, subject: 'physics', duration: 10, no_of_MCQ: 5, no_of_rearrangeQ: 5 }	
	#	}.to_json,	
	#	{ 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
	#	assert_equal 422, response.status	
	#	assert_equal Mime::JSON, response.content_type		
	#end		
end
