class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :text
      t.float :mark
      t.text :choices
      t.string :right_answer
      t.belongs_to :quiz, index: true

      t.timestamps
    end
  end
end
