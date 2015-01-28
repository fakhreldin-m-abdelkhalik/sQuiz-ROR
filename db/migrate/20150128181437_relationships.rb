class Relationships < ActiveRecord::Migration
  def change
	#many to many (group and quiz)
	create_table :groups_quizzes, id: false do |t|
		t.belongs_to :group, index: true
		t.belongs_to :quiz, index: true
	end
	#many to many (group and student)
	create_table :groups_students, id: false do |t|
		t.belongs_to :group, index: true
		t.belongs_to :student, index: true
	end
  end
end
