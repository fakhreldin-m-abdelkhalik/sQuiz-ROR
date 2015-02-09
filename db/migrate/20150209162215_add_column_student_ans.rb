class AddColumnStudentAns < ActiveRecord::Migration
  def change
  	add_column :student_result_quizzes, :student_ans, :string
  end
end
