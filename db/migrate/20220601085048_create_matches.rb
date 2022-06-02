class CreateMatches < ActiveRecord::Migration[6.1]
  def change
    create_table :matches do |t|
      t.date :date
      t.string :round
      t.references :player1, null: false, foreign_key: { to_table: :players }
      t.references :player2, null: false, foreign_key: { to_table: :players }
      t.references :tournament, null: false, foreign_key: true

      t.timestamps
    end
  end
end
