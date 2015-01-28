class CreateGraphs < ActiveRecord::Migration
  def change
    create_table :graphs do |t|
      t.belongs_to :graph_manager, index: true
      t.timestamps
    end
  end
end
