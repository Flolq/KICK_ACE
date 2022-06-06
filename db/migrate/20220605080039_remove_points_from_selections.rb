class RemovePointsFromSelections < ActiveRecord::Migration[6.1]
  def change
    remove_column :selections, :points, :integer
  end
end
