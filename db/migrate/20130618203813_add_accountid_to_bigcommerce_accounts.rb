class AddAccountidToBigcommerceAccounts < ActiveRecord::Migration
  def change
    add_column :bigcommerce_accounts, :account_id, :integer
  end
end
