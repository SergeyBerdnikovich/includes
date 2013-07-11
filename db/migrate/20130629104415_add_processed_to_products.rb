class AddProcessedToProducts < ActiveRecord::Migration
  def change
    add_column :products, :processed, :boolean
    add_column :products, :updated_at, :datetime 
    add_column :bigcommerce_accounts, :processed, :boolean
  end
end
