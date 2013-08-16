class AddStatusToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :active, :datetime, :null => true
  end
end
