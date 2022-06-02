class AddPlayerPointsToSelection < ActiveRecord::Migration[6.1]
  def change
    add_column :selections, :player_points, :integer
  end
end
