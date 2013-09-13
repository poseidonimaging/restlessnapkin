class CreateMenuItems < ActiveRecord::Migration
  def up
    create_table :menu_items do |t|
      t.string :name
      t.string :description
      t.string :price
      t.string :venue_id
      t.timestamps
    end
  end
end
