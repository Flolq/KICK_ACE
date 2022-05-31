class AddPositionToSelections < ActiveRecord::Migration[6.1]
  def change
    add_column :selections, :position, :integer
  end
end
