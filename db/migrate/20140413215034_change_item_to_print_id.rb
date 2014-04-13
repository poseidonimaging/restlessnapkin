class ChangeItemToPrintId < ActiveRecord::Migration
  def change
    rename_column :orders, :item_1, :print_id
  end
end
