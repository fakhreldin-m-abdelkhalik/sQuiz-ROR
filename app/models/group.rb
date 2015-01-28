class Group < ActiveRecord::Base
	belongs_to :instructor
	has_and_belongs_to_many :quizzes
	has_and_belongs_to_many :students
end
