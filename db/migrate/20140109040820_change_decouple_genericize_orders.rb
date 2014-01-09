class ChangeDecoupleGenericizeOrders < ActiveRecord::Migration
  def change
    rename_column :orders, :venue, :venue_id
    rename_column :orders, :firstname, :customer_id
    rename_column :orders, :drinks_1, :item_1
    rename_column :orders, :drinks_2, :item_2
    rename_column :orders, :drinks_3, :item_3
    rename_column :orders, :drinks_4, :item_4
  end
end
