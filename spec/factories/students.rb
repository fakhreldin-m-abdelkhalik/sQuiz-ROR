FactoryGirl.define do
  factory :student ,class: Student do
    name'student' 
    email 'abc@eng.asu.edu.eg' 
    password 'abc12345678'
  end
  factory :student1 ,class: Student do
    name'student1' 
    email 'abcdefg@eng.asu.edu.eg' 
    password 'abc12345678'
  end
end
