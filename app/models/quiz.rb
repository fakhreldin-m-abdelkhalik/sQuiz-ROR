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
	#validates_datetime :expiry_date, :after => lambda { DateTime.now.to_formatted_s(:short) } , 
    #:after_message => 'Quiz expiry date must be after current time'

	#This methods takes group_id as a parameter and assigns this quiz to the group and students in this group.
	def publish_quiz ( group_id )
		group = Group.find(group_id)
		quiz = self
		group.quizzes << quiz
		group.students.each  do |student|
		student.quizzes << quiz 
		end
	end
end
