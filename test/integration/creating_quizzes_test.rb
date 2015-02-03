class CreatingQuizzesTest < ActionDispatch::IntegrationTest	
	# test 'creates quiz' do	
	# 	post "/api/quizzes",	
	# 	{ quiz:	
	# 	{ name: 'Quiz1', subject: 'physics', duration: 10, no_of_MCQ: 5, no_of_rearrangeQ: 5 }	
	# 	}.to_json,	
	# 	{ 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
	# 	assert_equal 201, response.status	
	# 	assert_equal Mime::JSON, response.content_type	
	# 	quiz = json(response.body)	
	# end	
	# test 'does not create quiz with name nil' do	
	# 	post "/api/quizzes",	
	# 	{ quiz:	
	# 	{ name: nil, subject: 'physics', duration: 10, no_of_MCQ: 5, no_of_rearrangeQ: 5 }	
	# 	}.to_json,	
	# 	{ 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
	# 	assert_equal 422, response.status	
	# 	assert_equal Mime::JSON, response.content_type		
	# end		
end
