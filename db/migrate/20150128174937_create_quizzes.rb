class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.string :name
      t.string :subject
      t.integer :duration
      t.integer :no_of_MCQ
      t.integer :no_of_rearrangeQ
      t.belongs_to :instructor, index: true

      t.timestamps
    end
  end
end
