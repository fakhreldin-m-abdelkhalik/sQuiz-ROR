class Instructor < ActiveRecord::Base
	has_many :groups
	has_many :quizzes
end
