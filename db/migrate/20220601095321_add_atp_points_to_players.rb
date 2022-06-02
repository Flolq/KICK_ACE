class AddAtpPointsToPlayers < ActiveRecord::Migration[6.1]
  def change
    add_column :players, :atp_points, :integer
  end
end
