FactoryGirl.define do
  factory :quiz ,class: Quiz do
    name'Quiz1' 
    subject 'physics' 
    duration 10
    no_of_MCQ 5 
    no_of_rearrangeQ 5
  end
end
