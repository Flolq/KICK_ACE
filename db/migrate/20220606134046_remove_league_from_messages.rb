class RemoveLeagueFromMessages < ActiveRecord::Migration[6.1]
  def change
    remove_reference :messages, :league, null: false, foreign_key: true
  end
end
