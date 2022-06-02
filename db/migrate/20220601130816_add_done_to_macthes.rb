class AddDoneToMacthes < ActiveRecord::Migration[6.1]
  def change
    add_column :matches, :done, :boolean, default: false
  end
end
