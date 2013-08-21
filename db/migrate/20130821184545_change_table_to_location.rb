class ChangeTableToLocation < ActiveRecord::Migration
  def change
    rename_column :orders, :table, :location
  end
end
