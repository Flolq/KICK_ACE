class CreateSelections < ActiveRecord::Migration[6.1]
  def change
    create_table :selections do |t|
      t.string :progress
      t.integer :price
      t.references :team, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true

      t.timestamps
    end
  end
end
