class ChangeStripeTokenOnOrder < ActiveRecord::Migration
  def change
    rename_column :orders, :lastname, :stripe_token
  end
end
