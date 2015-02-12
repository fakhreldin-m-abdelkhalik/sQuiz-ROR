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
  factory :student2 ,class: Student do
    name'student2' 
    email 'abcdssefg@eng.asu.edu.eg' 
    password 'abc1ss2345678'
  end
  factory :student3 ,class: Student do
    name'student3' 
    email 'abcdefssasdxg@eng.asu.edu.eg' 
    password 'abc12as345678'
  end
end
