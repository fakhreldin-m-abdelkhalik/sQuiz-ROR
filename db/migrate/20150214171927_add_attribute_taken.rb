class AddAttributeTaken < ActiveRecord::Migration
  def change
  	add_column :student_result_quizzes, :taken, :integer
  end
end
