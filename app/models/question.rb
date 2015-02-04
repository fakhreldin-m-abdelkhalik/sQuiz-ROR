class Question < ActiveRecord::Base
	serialize :choices,Array
	belongs_to :quiz
	validates :text, presence: true
	validates :right_answer, presence: true
end
