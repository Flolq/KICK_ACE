class AddRoundNumberToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :round_number, :integer, default: 0
  end
end
