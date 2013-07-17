class CreateLiquors < ActiveRecord::Migration
  def change
    create_table :liquors do |t|
      t.string :liquor_type,     :null => false
      t.string :name,            :null => false
      t.text :description,       :null => true
      t.timestamps
    end
  end
end
