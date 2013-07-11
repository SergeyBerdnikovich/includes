class RenameBigcommerce < ActiveRecord::Migration
  def up
  	  rename_table :bigcommerces, :bigcommerce_accounts
  end

  def down
  end
end
