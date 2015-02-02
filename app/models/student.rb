class Student < ActiveRecord::Base
	before_save :ensure_authentication_token
 
 	 devise :database_authenticatable, :token_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
	has_and_belongs_to_many :groups
	has_many :student_result_quizzes
	has_many :quizzes, :through => :student_result_quizzes
end	
