class StudentResultQuiz < ActiveRecord::Base
	serialize :student_ans,Array
	belongs_to :student
	belongs_to :quiz
end
