class AddRoundNumberToSelections < ActiveRecord::Migration[6.1]
  def change
    add_column :selections, :round_number, :integer, default: 0
  end
end
