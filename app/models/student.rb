class Student < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	has_and_belongs_to_many :groups
	has_many :student_result_quizzes
	has_many :quizzes, :through => :student_result_quizzes
end	
