class AddColumnsToOrders < ActiveRecord::Migration
  def up
  	add_column :orders, :drinks_2, :string, :null => true
  	add_column :orders, :drinks_3, :string, :null => true
  	add_column :orders, :drinks_4, :string, :null => true
  	add_column :orders, :received_at, :datetime, :null => true
  	add_column :orders, :fulfilled_at, :datetime, :null => true
  end
end
