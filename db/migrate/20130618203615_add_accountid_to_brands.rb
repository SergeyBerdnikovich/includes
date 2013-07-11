class AddAccountidToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :account_id, :integer
  end
end
