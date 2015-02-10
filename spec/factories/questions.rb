FactoryGirl.define do
  factory :question ,class: Question do
    text 'What is the answer ?' 
    mark 2 
    choices ["a","b","c","d"]
    right_answer "a"
  end
end