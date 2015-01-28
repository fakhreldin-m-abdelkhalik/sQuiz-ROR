class Question < ActiveRecord::Base
	serialize :choices,Array
	belongs_to :quiz
end
