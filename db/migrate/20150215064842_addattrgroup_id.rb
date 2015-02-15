class AddattrgroupId < ActiveRecord::Migration
  def change
  	add_column :student_result_quizzes, :group_id, :integer
  end
end
