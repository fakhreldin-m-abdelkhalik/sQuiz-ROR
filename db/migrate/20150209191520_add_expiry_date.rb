class AddExpiryDate < ActiveRecord::Migration
  def change
  	add_column :quizzes, :expiry_date, :datetime
  end
end
