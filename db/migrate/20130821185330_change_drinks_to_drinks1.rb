class ChangeDrinksToDrinks1 < ActiveRecord::Migration
  def change
    rename_column :orders, :drinks, :drinks_1
  end
end
