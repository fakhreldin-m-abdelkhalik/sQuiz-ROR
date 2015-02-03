require 'rails_helper'

RSpec.describe Quiz, :type => :model do
  it "publishes quiz by assigning it to a specific group and its students" do
  	quiz = FactoryGirl.create(:quiz)
  	student1 = FactoryGirl.create(:student)
  	student2 = FactoryGirl.create(:student1)
  	group = FactoryGirl.create(:group) 
  	group.students << student1
  	group.students << student2
  	quiz.publish_quiz(group.id)
  	expect(group.quizzes).to include(quiz)
  	expect(student1.quizzes).to include(quiz)
  	expect(student2.quizzes).to include(quiz)
  end
end
