class AddPrinterActive < ActiveRecord::Migration
  def change
    add_column :venues, :printer_active, :boolean, :null => true
  end
end
