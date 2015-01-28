class Quiz < ActiveRecord::Base
	has_and_belongs_to_many :groups
	belongs_to :instructor
	has_many :student_result_quizzes
	has_many :students, :through => :student_result_quizzes
	has_many :questions 
end
