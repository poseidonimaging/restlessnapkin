class AdditionalVenueInformation < ActiveRecord::Migration
  def change
    add_column :venues, :address, :string, :null => true
    add_column :venues, :city, :string, :null => true
    add_column :venues, :state, :string, :null => true
    add_column :venues, :postal_code, :string, :null => true
    add_column :venues, :phone, :string, :null => true
    add_column :venues, :printer_id, :string, :null => true
  end
end
