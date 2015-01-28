class Student < ActiveRecord::Base
	has_and_belongs_to_many :groups
	has_many :quizzes, through: :student_result_quizzes
end
