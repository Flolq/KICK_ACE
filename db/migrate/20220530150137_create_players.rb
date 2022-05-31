class CreatePlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :players do |t|
      t.string :first_name
      t.string :last_name
      t.integer :ranking
      t.integer :min_price
      t.string :nationality

      t.timestamps
    end
  end
end
