class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.belongs_to :instructor, index: true

      t.timestamps
    end
  end
end
