class AddInfosToPlayers < ActiveRecord::Migration[6.1]
  def change
    add_column :players, :date_of_birth, :date
    add_column :players, :competitions_played, :integer
    add_column :players, :competitions_won, :integer
    add_column :players, :matches_played, :integer
    add_column :players, :matches_won, :integer
  end
end
