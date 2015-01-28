class CreateStudentResultQuizzes < ActiveRecord::Migration
  def change
    create_table :student_result_quizzes do |t|
      t.float :result
      t.belongs_to :quiz, index: true
      t.belongs_to :student, index: true

      t.timestamps
    end
  end
end
