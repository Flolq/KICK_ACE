class AddLevelToTournaments < ActiveRecord::Migration[6.1]
  def change
    rename_column :tournaments, :type, :level
  end
end
