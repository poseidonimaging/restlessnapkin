class ChangeStripeIdOnOrder < ActiveRecord::Migration
  def change
    rename_column :orders, :stripe_token, :stripe_id
  end
end
