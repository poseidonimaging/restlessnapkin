class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :name,   :null => false
      t.string :handle, :null => false
      t.timestamps
    end

    add_index :venues, :handle, :unique => true
  end
end
