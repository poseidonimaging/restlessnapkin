class ChangeLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :customer_id, :integer
    add_column :line_items, :venue_id, :integer
  end
end
