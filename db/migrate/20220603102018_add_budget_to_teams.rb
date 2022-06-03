class AddBudgetToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :budget, :integer
  end
end
