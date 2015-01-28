class CreateStudentResultQuizzes < ActiveRecord::Migration
  def change
    create_table :student_result_quizzes do |t|
      t.float :result

      t.timestamps
    end
  end
end
