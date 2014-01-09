class CreateCustomers < ActiveRecord::Migration
  def up
    create_table :customers do |t|
      t.string :firstname
      t.string :lastname
      t.string :phone
      t.string :email, :null => false
      t.string :stripe_id, :null => false
      t.timestamps
    end
  end
end
