FactoryGirl.define do
  factory :instructor ,class: Instructor do
    name'instructor' 
    email 'a@eng.asu.edu.eg' 
    password 'abc12345678'
  end
  factory :instructor1 ,class: Instructor do
    name'instructor1' 
    email 'b@eng.asu.edu.eg' 
    password 'abc12345678'
  end
end
