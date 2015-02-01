class Quiz < ActiveRecord::Base
	#relationships
	has_and_belongs_to_many :groups
	belongs_to :instructor
	has_many :student_result_quizzes
	has_many :students, :through => :student_result_quizzes
	has_many :questions 

	#validations
	validates :name ,presence: true
	validates :subject ,presence: true
	validates :duration ,presence: true
end
