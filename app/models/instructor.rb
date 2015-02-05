class Instructor < ActiveRecord::Base
  	acts_as_token_authenticatable

  	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	has_many :groups
	has_many :quizzes
end
