class CreateOrders < ActiveRecord::Migration
  def up
  	create_table :orders do |t|
  		t.string :venue
  		t.string :table
  		t.string :firstname
  		t.string :lastname
  		t.string :phone
  		t.string :drinks
  		t.timestamps
  	end
  	Order.create(venue: "Hulahut", table: "8", firstname: "Chad", lastname: "Sakonchick", phone: "5126199115", drinks: "4 Miller Lite Drafts" )
	Order.create(venue: "219west", table: "3", firstname: "Joey", lastname: "Leak", phone: "2149069855", drinks: "1 Ketel One and Tonic with Lemon" )  
  end

  def down
  	drop_table :orders
  end
end
