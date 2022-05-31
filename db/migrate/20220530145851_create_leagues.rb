class CreateLeagues < ActiveRecord::Migration[6.1]
  def change
    create_table :leagues do |t|
      t.string :name
      t.integer :number_of_users
      t.string :token
      t.string :round_progress
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
