class Student < ActiveRecord::Base
	acts_as_token_authenticatable
 
 	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

	has_and_belongs_to_many :groups
	has_many :student_result_quizzes
	has_many :quizzes, :through => :student_result_quizzes
end	
