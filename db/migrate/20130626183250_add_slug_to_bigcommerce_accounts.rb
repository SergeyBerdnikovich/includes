class AddSlugToBigcommerceAccounts < ActiveRecord::Migration
  def change
    add_column :bigcommerce_accounts, :slug, :string
    add_index :bigcommerce_accounts, :slug, unique: true
  end
end
