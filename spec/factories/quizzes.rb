FactoryGirl.define do
  factory :quiz ,class: Quiz do
    name'Quiz1' 
    subject 'physics' 
    duration 10
    no_of_MCQ 1 
    no_of_rearrangeQ 1
  end
end
