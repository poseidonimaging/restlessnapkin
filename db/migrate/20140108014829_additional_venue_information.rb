class AdditionalVenueInformation < ActiveRecord::Migration
  def up
    add_column :venues, :address, :string, :null => true
    add_column :venues, :city, :string, :null => true
    add_column :venues, :state, :string, :null => true
    add_column :venues, :postal_code, :string, :null => true
    add_column :venues, :phone, :string, :null => true
  end
end
