class CreateGraphManagers < ActiveRecord::Migration
  def change
    create_table :graph_managers do |t|

      t.timestamps
    end
  end
end
