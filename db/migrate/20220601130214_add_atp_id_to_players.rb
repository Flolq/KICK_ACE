class AddAtpIdToPlayers < ActiveRecord::Migration[6.1]
  def change
    add_column :players, :atpid, :string
  end
end
