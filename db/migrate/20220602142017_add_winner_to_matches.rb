class AddWinnerToMatches < ActiveRecord::Migration[6.1]
  def change
    add_reference :matches, :winner, null: true, foreign_key: { to_table: :players }
  end
end
