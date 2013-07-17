class CreateLiquorsVenues < ActiveRecord::Migration
  def change
    create_table :liquors_venues do |t|
      t.integer :liquor_id, :null => false
      t.integer :venue_id, :null => false
      t.boolean :well, :null => false
      t.timestamps
    end

    add_index :liquors_venues, [:liquor_id, :venue_id], :unique => true
  end
end
