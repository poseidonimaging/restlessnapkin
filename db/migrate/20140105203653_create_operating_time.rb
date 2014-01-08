class CreateOperatingTime < ActiveRecord::Migration
  def change
    create_table :operating_times do |t|
      t.integer :venue_id, :null => false
      t.integer :day_of_week, :null => false
      t.integer :start_hour, :null => false
      t.integer :end_hour, :null => false
      t.timestamps
    end
  end
end
