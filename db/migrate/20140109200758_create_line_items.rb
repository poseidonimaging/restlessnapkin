class CreateLineItems < ActiveRecord::Migration
  def up
    create_table :line_items do |t|
      t.integer :order_id, :null => false
      t.integer :quantity, :null => false
      t.string :item, :null => false
      t.timestamps
    end
  end
end
