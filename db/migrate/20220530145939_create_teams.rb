class CreateTeams < ActiveRecord::Migration[6.1]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :progress
      t.integer :points
      t.references :user, null: false, foreign_key: true
      t.references :league, null: false, foreign_key: true

      t.timestamps
    end
  end
end
