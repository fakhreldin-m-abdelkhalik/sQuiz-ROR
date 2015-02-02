class Instructor < ActiveRecord::Base
  	before_save :ensure_authentication_token

  	devise :database_authenticatable, :token_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	has_many :groups
	has_many :quizzes
end
